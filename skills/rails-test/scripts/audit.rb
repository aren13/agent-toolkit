#!/usr/bin/env ruby
# Audit script — invoked by /rails-test-audit and the Lefthook pre-push hook.
$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require 'audit_runner'
require 'diff_coverage'
require 'json'
require 'digest'
require 'optparse'
require 'fileutils'
require 'shellwords'

options = { hook: nil, base_ref: 'testing' }
OptionParser.new do |o|
  o.on('--hook MODE', 'Mode: pre-push (terse output)') { |m| options[:hook] = m }
  o.on('--base REF', 'Base ref (default: testing)') { |r| options[:base_ref] = r }
end.parse!(ARGV)

class GitAdapter
  def changed_files(base)
    `git diff #{base.shellescape}...HEAD --name-only`.lines.map(&:strip).reject(&:empty?)
  end

  def diff_lines(base)
    DiffCoverage.parse_diff_lines(`git diff --unified=0 #{base.shellescape}...HEAD`)
  end

  def diff_sha(base)
    Digest::SHA1.hexdigest(`git diff #{base.shellescape}...HEAD`)[0, 12]
  end
end

class SpecRunner
  def run(spec_files)
    return { passed: true, hits: {} } if spec_files.empty?

    cmd = "COVERAGE=true bundle exec rspec #{spec_files.shelljoin}"
    output = `#{cmd}`
    passed = $?.success?
    { passed: passed, hits: load_simplecov_hits, output: output }
  end

  private

  def load_simplecov_hits
    json = 'coverage/.resultset.json'
    return {} unless File.exist?(json)

    raw = JSON.parse(File.read(json))
    suite = raw.values.first || {}
    coverage = suite['coverage'] || {}
    coverage.each_with_object({}) do |(abs_path, data), out|
      rel = abs_path.sub("#{Dir.pwd}/", '')
      out[rel] = data.is_a?(Hash) ? data['lines'] : data
    end
  end
end

def format_md(result, terse: false)
  lines = []
  fails = result.findings.select { |f| f.level == :fail }
  warns = result.findings.select { |f| f.level == :warn }

  if terse
    fails.each { |f| lines << "  ❌ FAIL — #{f.message}#{" (#{f.file})" if f.file}" }
    if fails.any?
      lines << ''
      lines << '  Push blocked. Run /rails-test-audit for details.'
      lines << '  To bypass (emergency only): git push --no-verify'
    else
      warn_count = warns.size
      lines << "  ✅ Audit passed (#{warn_count} warning#{warn_count == 1 ? '' : 's'})"
    end
  else
    lines << '## Rails Test Audit'
    lines << ''
    if fails.any?
      lines << '### ❌ Failures (must fix before push)'
      fails.each { |f| lines << "- #{f.message} — #{f.file}#{":#{f.line}" if f.line}" }
      lines << ''
    end
    if warns.any?
      lines << '### ⚠️  Warnings (review)'
      warns.each { |f| lines << "- #{f.message} — #{f.file}#{":#{f.line}" if f.line}" }
      lines << ''
    end
    lines << '### Stats'
    lines << "- specs run: #{result.stats[:specs_run] || 0}"
    lines << "- failures: #{result.stats[:fails] || 0}, warnings: #{result.stats[:warns] || 0}"
    lines << ''
    lines << "Exit: #{result.exit_code}"
  end
  lines.join("\n")
end

git = GitAdapter.new
sha = git.diff_sha(options[:base_ref])
cache_path = "tmp/audit_#{sha}.json"

if File.exist?(cache_path) && (Time.now - File.mtime(cache_path)) < 300
  cached = JSON.parse(File.read(cache_path), symbolize_names: true)
  puts cached[:output]
  exit cached[:exit_code]
end

runner = AuditRunner.new(git: git, spec_runner: SpecRunner.new)
result = runner.run

output = format_md(result, terse: options[:hook] == 'pre-push')
puts output

FileUtils.mkdir_p('tmp')
File.write(cache_path, JSON.dump(output: output, exit_code: result.exit_code))

exit result.exit_code
