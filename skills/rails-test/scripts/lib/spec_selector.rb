require 'fileutils'
require 'tmpdir'

module SpecSelector
  EXEMPT_PREFIXES = %w[
    app/assets/
    app/javascript/
    app/views/
  ].freeze

  module_function

  def direct_specs_for(changed_paths)
    changed_paths
      .select { |p| p.start_with?('app/') && p.end_with?('.rb') }
      .reject { |p| EXEMPT_PREFIXES.any? { |pre| p.start_with?(pre) } }
      .map { |p| p.sub(%r{\Aapp/}, 'spec/').sub(/\.rb\z/, '_spec.rb') }
  end

  def class_names_in(content)
    names = []
    stack = []
    content.each_line do |line|
      case line
      when /^\s*module\s+([A-Z][A-Za-z0-9_:]*)/
        full = (stack + [Regexp.last_match(1)]).join('::')
        names << full
        stack << Regexp.last_match(1)
      when /^\s*class\s+([A-Z][A-Za-z0-9_:]*)/
        full = (stack + [Regexp.last_match(1)]).join('::')
        names << full
        stack << Regexp.last_match(1)
      when /^\s*end\s*$/
        stack.pop
      end
    end
    names
  end

  def dependent_specs_for(class_names, spec_glob:, cap: 50)
    return [] if class_names.empty?

    pattern = class_names.map { |n| Regexp.escape(n) }.join('|')
    matches = Dir.glob(spec_glob).select do |path|
      File.read(path) =~ /\b(#{pattern})\b/
    end
    matches.sort_by { |p| -File.mtime(p).to_i }.first(cap)
  end

  def select(changed_app_files:, spec_glob: 'spec/**/*_spec.rb', cap: 50)
    direct = direct_specs_for(changed_app_files).select { |p| File.exist?(p) }
    class_names = changed_app_files
                  .select { |p| File.exist?(p) }
                  .flat_map { |p| class_names_in(File.read(p)) }
                  .uniq
    deps = dependent_specs_for(class_names, spec_glob: spec_glob, cap: cap)
    (direct + deps).uniq
  end
end
