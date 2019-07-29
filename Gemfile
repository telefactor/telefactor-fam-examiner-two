# frozen_string_literal: true

ruby '2.6.1'
source 'https://rubygems.org'

gemspec

group :test do
  # Test framework
  gem 'rspec', '~> 3.8'

  # Debugging
  gem 'awesome_print', '~> 1.8'
  gem 'pry'
  gem 'pry-byebug'
end

group :lint do
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end
