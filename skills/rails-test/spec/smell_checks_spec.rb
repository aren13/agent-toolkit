require 'smell_checks'
require 'fileutils'
require 'tmpdir'

RSpec.describe SmellChecks do
  let(:tmpdir) { Dir.mktmpdir }
  after { FileUtils.rm_rf(tmpdir) }

  def write(path, content)
    full = File.join(tmpdir, path)
    FileUtils.mkdir_p(File.dirname(full))
    File.write(full, content)
    full
  end

  describe '.spec_missing' do
    it 'returns a fail Finding when expected spec does not exist' do
      f = described_class.spec_missing('app/models/foo.rb', '/nonexistent/path/spec.rb')
      expect(f.level).to eq(:fail)
      expect(f.file).to eq('app/models/foo.rb')
      expect(f.message).to include('expected /nonexistent/path/spec.rb')
    end

    it 'returns nil when spec exists' do
      path = write('spec/models/foo_spec.rb', '')
      expect(described_class.spec_missing('app/models/foo.rb', path)).to be_nil
    end
  end

  describe '.spec_empty' do
    it 'flags spec with no it/example/scenario blocks' do
      path = write('spec/x_spec.rb', "require 'rails_helper'\nRSpec.describe Foo do\nend")
      expect(described_class.spec_empty(path).level).to eq(:fail)
    end

    it 'passes spec with at least one it block' do
      path = write('spec/x_spec.rb', "RSpec.describe Foo do\n  it { is_expected.to be_truthy }\nend")
      expect(described_class.spec_empty(path)).to be_nil
    end
  end

  describe '.no_real_expectations' do
    it 'flags spec with zero expect calls' do
      path = write('spec/x_spec.rb', "describe Foo do\n  it 'works' do\n    Foo.new\n  end\nend")
      expect(described_class.no_real_expectations(path).level).to eq(:fail)
    end

    it 'passes spec with expect call' do
      path = write('spec/x_spec.rb', "describe Foo do\n  it { expect(Foo.new).to be_a(Foo) }\nend")
      expect(described_class.no_real_expectations(path)).to be_nil
    end

    it 'passes spec using is_expected' do
      path = write('spec/x_spec.rb', "describe Foo do\n  it { is_expected.to be_truthy }\nend")
      expect(described_class.no_real_expectations(path)).to be_nil
    end
  end

  describe '.tautological_expect' do
    it 'warns on expect(true).to be true patterns' do
      path = write('spec/x_spec.rb', 'it { expect(true).to be true }')
      expect(described_class.tautological_expect(path).level).to eq(:warn)
    end

    it 'warns on expect(klass).to be_truthy' do
      path = write('spec/x_spec.rb', 'it { expect(Klass).to be_truthy }')
      expect(described_class.tautological_expect(path).level).to eq(:warn)
    end
  end

  describe '.mock_heavy_ratio' do
    it 'warns when allow/receive count > 3x expect count' do
      content = ((['allow(x).to receive(:y)'] * 12) + (['expect(z).to eq(1)'] * 3)).join("\n")
      path = write('spec/x_spec.rb', content)
      expect(described_class.mock_heavy_ratio(path).level).to eq(:warn)
    end

    it 'passes when ratio is healthy' do
      content = ((['allow(x).to receive(:y)'] * 2) + (['expect(z).to eq(1)'] * 5)).join("\n")
      path = write('spec/x_spec.rb', content)
      expect(described_class.mock_heavy_ratio(path)).to be_nil
    end
  end

  describe '.factory_no_db_assert' do
    it 'warns when create() is called without change/reload/exists/count/where' do
      path = write('spec/x_spec.rb', "create(:user)\nexpect(user.name).to eq('x')")
      expect(described_class.factory_no_db_assert(path).level).to eq(:warn)
    end

    it 'passes when create() is followed by a change matcher' do
      path = write('spec/x_spec.rb', 'expect { create(:user) }.to change(User, :count).by(1)')
      expect(described_class.factory_no_db_assert(path)).to be_nil
    end
  end

  describe '.pending_or_skipped' do
    it 'warns on pending blocks' do
      path = write('spec/x_spec.rb', "it 'broken' do\n  pending 'fix later'\nend")
      expect(described_class.pending_or_skipped(path).level).to eq(:warn)
    end

    it 'warns on xit' do
      path = write('spec/x_spec.rb', "xit 'todo' do\nend")
      expect(described_class.pending_or_skipped(path).level).to eq(:warn)
    end
  end
end
