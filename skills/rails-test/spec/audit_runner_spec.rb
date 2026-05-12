require 'audit_runner'
require 'fileutils'
require 'tmpdir'

RSpec.describe AuditRunner do
  let(:tmpdir) { Dir.mktmpdir }
  after { FileUtils.rm_rf(tmpdir) }

  let(:fake_git) { instance_double('GitAdapter') }
  let(:fake_specs) { instance_double('SpecRunner') }

  let(:runner) do
    described_class.new(
      git: fake_git,
      spec_runner: fake_specs,
      config: { base_ref: 'testing', diff_coverage_warn: 80, diff_coverage_fail: 50 }
    )
  end

  it 'returns exit code 0 when all checks pass' do
    Dir.chdir(tmpdir) do
      FileUtils.mkdir_p('spec/models')
      File.write('spec/models/foo_spec.rb', "describe Foo do\n  it { is_expected.to be_truthy }\nend")
      allow(fake_git).to receive(:changed_files).and_return(['app/models/foo.rb'])
      allow(fake_git).to receive(:diff_lines).and_return('app/models/foo.rb' => [1, 2])
      allow(fake_specs).to receive(:run).and_return(passed: true, hits: { 'app/models/foo.rb' => [nil, 1, 1] })
      allow(SpecSelector).to receive(:select).and_return(['spec/models/foo_spec.rb'])

      result = runner.run
      expect(result.exit_code).to eq(0)
      expect(result.findings.count { |f| f.level == :fail }).to eq(0)
    end
  end

  it 'returns exit code 2 when spec is missing' do
    allow(fake_git).to receive(:changed_files).and_return(['app/services/bar.rb'])
    allow(fake_git).to receive(:diff_lines).and_return({})
    allow(fake_specs).to receive(:run).and_return(passed: true, hits: {})
    allow(SpecSelector).to receive(:select).and_return([])

    result = runner.run
    expect(result.exit_code).to eq(2)
    expect(result.findings.any? { |f| f.message =~ %r{expected spec/services/bar_spec\.rb} }).to be true
  end

  it 'returns exit code 1 for warnings only' do
    Dir.chdir(tmpdir) do
      FileUtils.mkdir_p('spec/models')
      File.write('spec/models/foo_spec.rb',
                 "describe Foo do\n  it { pending 'todo'; expect(1).to eq(1) }\nend")
      allow(fake_git).to receive(:changed_files).and_return(['app/models/foo.rb'])
      allow(fake_git).to receive(:diff_lines).and_return('app/models/foo.rb' => [1])
      allow(fake_specs).to receive(:run).and_return(passed: true, hits: { 'app/models/foo.rb' => [nil, 1] })
      allow(SpecSelector).to receive(:select).and_return(['spec/models/foo_spec.rb'])

      result = runner.run
      expect(result.exit_code).to eq(1)
    end
  end
end
