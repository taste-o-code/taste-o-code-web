require 'rubygems'
require 'spork'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails'
  puts "Running coverage tool\n"
end

Spork.prefork do

  ENV['RAILS_ENV'] ||= 'test'

  require 'rails/application'
  require 'rails/mongoid'
  Spork.trap_class_method(Rails::Mongoid, :load_models)
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

  require File.expand_path('../../config/environment', __FILE__)

  require 'rspec/rails'
  require 'capybara/rspec'

  RSpec.configure do |config|
    config.mock_with :rspec

    config.include Mongoid::Matchers

    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm      = :mongoid
  end

end

Spork.each_run do
  DatabaseCleaner.clean
  FactoryGirl.reload
end