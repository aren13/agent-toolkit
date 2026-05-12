$LOAD_PATH.unshift File.expand_path('../scripts/lib', __dir__)

require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.order = :random
  Kernel.srand config.seed
end
