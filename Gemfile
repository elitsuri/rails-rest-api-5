source 'https://rubygems.org'
ruby '3.3.0'

gem 'rails', '~> 7.1'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rack-cors'
gem 'bcrypt', '~> 3.1'
gem 'jwt', '~> 2.7'
gem 'active_model_serializers', '~> 0.10'
gem 'kaminari'
gem 'redis', '~> 5.0'
gem 'sidekiq', '~> 7.2'
gem 'dotenv-rails', groups: [:development, :test]

group :development, :test do
  gem 'rspec-rails', '~> 6.1'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'database_cleaner-active_record'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end
