require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods

  config.before(:suite)  { DatabaseCleaner.strategy = :transaction; DatabaseCleaner.clean_with(:truncation) }
  config.around(:each)   { |ex| DatabaseCleaner.cleaning { ex.run } }
end

Shoulda::Matchers.configure do |c|
  c.integrate { |with| with.test_framework(:rspec); with.library(:rails) }
end
