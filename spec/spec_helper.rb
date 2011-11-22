require 'rubygems'
require 'spork'

if ENV["COV"]
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
    config.include Devise::TestHelpers, :type => :controller
    config.include FlashMatcher, :type => :request

    require 'database_cleaner'

    config.before(:suite) do
      DatabaseCleaner.orm = :mongoid
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end
  end

  Capybara.javascript_driver = :webkit

  OmniAuth.config.test_mode = true
  # We can delete :info hash when https://github.com/intridea/omniauth/commit/885bb1639e0ec0b1b268338891b11b17929ffaef released.
  OmniAuth.config.add_mock :google, :uid => '123456', :info => { :name => 'Bob Example' }

end

Spork.each_run do
  FactoryGirl.reload
end
