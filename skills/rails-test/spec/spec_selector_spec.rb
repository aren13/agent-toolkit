require 'spec_selector'
require 'fileutils'
require 'tmpdir'

RSpec.describe SpecSelector do
  describe '.direct_specs_for' do
    it 'maps app paths to spec paths' do
      changed = ['app/models/donation.rb', 'app/services/foo/bar.rb']
      expect(described_class.direct_specs_for(changed))
        .to eq(['spec/models/donation_spec.rb', 'spec/services/foo/bar_spec.rb'])
    end

    it 'ignores non-app/ paths' do
      changed = ['app/models/user.rb', 'config/routes.rb', 'db/schema.rb']
      expect(described_class.direct_specs_for(changed))
        .to eq(['spec/models/user_spec.rb'])
    end

    it 'ignores asset/view/javascript paths' do
      changed = [
        'app/assets/foo.css',
        'app/views/users/show.html.erb',
        'app/javascript/x.js',
        'app/models/x.rb'
      ]
      expect(described_class.direct_specs_for(changed))
        .to eq(['spec/models/x_spec.rb'])
    end
  end

  describe '.class_names_in' do
    it 'extracts top-level classes and modules' do
      content = <<~RUBY
        class Foo::Bar < ApplicationRecord
        end
        module Quux
          class Zot
          end
        end
      RUBY
      expect(described_class.class_names_in(content))
        .to contain_exactly('Foo::Bar', 'Quux', 'Quux::Zot')
    end

    it 'returns empty for content with no class/module' do
      expect(described_class.class_names_in("def foo; end\n")).to eq([])
    end
  end

  describe '.dependent_specs_for' do
    let(:tmpdir) { Dir.mktmpdir }
    after { FileUtils.rm_rf(tmpdir) }

    it 'finds specs that mention the class names' do
      Dir.chdir(tmpdir) do
        FileUtils.mkdir_p('spec/models')
        File.write('spec/models/order_spec.rb', "describe Order do\n  let(:user) { User.new }\nend")
        File.write('spec/models/account_spec.rb', "describe Account do\nend")
        result = described_class.dependent_specs_for(['User'], spec_glob: 'spec/**/*_spec.rb')
        expect(result).to eq(['spec/models/order_spec.rb'])
      end
    end

    it 'caps results at the configured maximum' do
      Dir.chdir(tmpdir) do
        FileUtils.mkdir_p('spec/models')
        60.times do |i|
          File.write("spec/models/x#{i}_spec.rb", "describe X do\n  User\nend")
        end
        result = described_class.dependent_specs_for(['User'], spec_glob: 'spec/**/*_spec.rb', cap: 50)
        expect(result.size).to eq(50)
      end
    end
  end

  describe '.select' do
    it 'unions direct + dependent specs and removes duplicates' do
      allow(described_class).to receive(:dependent_specs_for)
        .and_return(['spec/models/donation_spec.rb', 'spec/services/payments_spec.rb'])
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return('')
      result = described_class.select(
        changed_app_files: ['app/models/donation.rb'],
        spec_glob: 'spec/**/*_spec.rb'
      )
      expect(result).to eq(['spec/models/donation_spec.rb', 'spec/services/payments_spec.rb'])
    end
  end
end
