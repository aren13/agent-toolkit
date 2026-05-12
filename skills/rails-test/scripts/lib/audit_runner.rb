require 'spec_selector'
require 'smell_checks'
require 'diff_coverage'

class AuditRunner
  Result = Struct.new(:exit_code, :findings, :stats, keyword_init: true)

  EXEMPT_PATTERNS = [
    %r{\Aapp/assets/}, %r{\Aapp/javascript/}, %r{\Aapp/views/},
    %r{\Aapp/cells/}, %r{\Aapp/datatables/},
    %r{\Aapp/lib/.*/version\.rb\z}
  ].freeze

  def initialize(git:, spec_runner:, config: {})
    @git = git
    @spec_runner = spec_runner
    @config = {
      base_ref: 'testing',
      diff_coverage_warn: 80,
      diff_coverage_fail: 50,
      exempt_patterns: EXEMPT_PATTERNS
    }.merge(config)
  end

  def run
    findings = []
    changed = @git.changed_files(@config[:base_ref])
    diff_lines = @git.diff_lines(@config[:base_ref])

    app_changes = changed.select { |p| p.start_with?('app/') && p.end_with?('.rb') }
    auditable = app_changes.reject { |p| @config[:exempt_patterns].any? { |re| p =~ re } }

    auditable.each do |app_path|
      expected = app_path.sub(%r{\Aapp/}, 'spec/').sub(/\.rb\z/, '_spec.rb')
      f = SmellChecks.spec_missing(app_path, expected)
      findings << f if f
    end

    spec_files = SpecSelector.select(changed_app_files: app_changes)

    if spec_files.empty?
      return finalize(findings, 0, {})
    end

    spec_result = @spec_runner.run(spec_files)
    unless spec_result[:passed]
      findings << SmellChecks::Finding.new(
        level: :fail, file: nil, line: nil, message: 'spec run failed'
      )
      return finalize(findings, 0, spec_result)
    end

    spec_files.select { |s| File.exist?(s) }.each do |spec|
      findings.concat([
        SmellChecks.spec_empty(spec),
        SmellChecks.no_real_expectations(spec),
        SmellChecks.tautological_expect(spec),
        SmellChecks.mock_heavy_ratio(spec),
        SmellChecks.factory_no_db_assert(spec),
        SmellChecks.pending_or_skipped(spec)
      ].compact)
    end

    cov_report = DiffCoverage.report(spec_result[:hits] || {}, diff_lines)
    cov_report.each do |file, info|
      next if info[:percent] >= @config[:diff_coverage_warn]

      level = info[:percent] < @config[:diff_coverage_fail] ? :fail : :warn
      findings << SmellChecks::Finding.new(
        level: level, file: file, line: nil,
        message: "diff coverage #{info[:percent]}% (#{info[:covered]}/#{info[:total]} changed lines)"
      )
    end

    finalize(findings, spec_files.size, cov_report)
  end

  private

  def finalize(findings, specs_run, cov_report)
    fails = findings.count { |f| f.level == :fail }
    warns = findings.count { |f| f.level == :warn }
    exit_code = if fails.positive?
                  2
                elsif warns.positive?
                  1
                else
                  0
                end
    Result.new(
      exit_code: exit_code,
      findings: findings,
      stats: { specs_run: specs_run, coverage: cov_report, fails: fails, warns: warns }
    )
  end
end
