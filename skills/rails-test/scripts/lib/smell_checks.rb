module SmellChecks
  Finding = Struct.new(:level, :file, :line, :message, keyword_init: true)

  TAUTOLOGY_PATTERNS = [
    /expect\(\s*true\s*\)\.to\s+be(\s+true|_truthy)/,
    /expect\(\s*[A-Z][\w:]*\s*\)\.to\s+be_truthy/,
    /expect\(\s*nil\s*\)\.to\s+be(\s+nil|_nil)/
  ].freeze

  PENDING_PATTERNS = /\b(pending|skip|xit|xdescribe|xcontext)\b/

  module_function

  def spec_missing(app_file, expected_spec_path)
    return nil if File.exist?(expected_spec_path)

    Finding.new(level: :fail, file: app_file, line: nil,
                message: "expected #{expected_spec_path}")
  end

  def spec_empty(spec_path)
    content = File.read(spec_path)
    return nil if content =~ /\b(it|example|scenario)\b/

    Finding.new(level: :fail, file: spec_path, line: nil,
                message: 'spec file has no it/example/scenario blocks')
  end

  def no_real_expectations(spec_path)
    content = File.read(spec_path)
    return nil if content =~ /\b(expect|is_expected|should)\b/

    Finding.new(level: :fail, file: spec_path, line: nil,
                message: 'no expect/is_expected/should calls found')
  end

  def tautological_expect(spec_path)
    content = File.read(spec_path)
    found = content.each_line.with_index(1).find do |line, _|
      TAUTOLOGY_PATTERNS.any? { |p| line =~ p }
    end
    return nil unless found

    Finding.new(level: :warn, file: spec_path, line: found.last,
                message: 'tautological expectation (always passes)')
  end

  def mock_heavy_ratio(spec_path)
    content = File.read(spec_path)
    mocks = content.scan(/\ballow\([^)]+\)\.to\s+receive/).size
    expects = content.scan(/\bexpect\([^)]+\)\.to\b/).size
    return nil if expects.zero? && mocks.zero?
    return nil if expects.positive? && mocks <= expects * 3

    Finding.new(level: :warn, file: spec_path, line: nil,
                message: "#{mocks} mocks vs #{expects} expects — testing the mocks?")
  end

  def factory_no_db_assert(spec_path)
    content = File.read(spec_path)
    return nil unless content =~ /\bcreate\(/
    return nil if content =~ /\.to\s+change\(|\.reload\b|exists\?\s*\(|\.count\b|\.where\(/

    Finding.new(level: :warn, file: spec_path, line: nil,
                message: 'create(...) called but no DB-state assertion (change/reload/count/where/exists?)')
  end

  def pending_or_skipped(spec_path)
    content = File.read(spec_path)
    found = content.each_line.with_index(1).find { |line, _| line =~ PENDING_PATTERNS }
    return nil unless found

    Finding.new(level: :warn, file: spec_path, line: found.last,
                message: 'pending/skip/xit/xdescribe present')
  end
end
