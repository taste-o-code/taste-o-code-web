source 'http://rubygems.org'

gem 'rails', '~> 3.1.1'

gem 'mongoid',  '~> 2.3.1'
gem 'mongoid_auto_increment', '~> 0.0.8'
gem 'bson_ext', '~> 1.4.0'

gem 'haml',       '~> 3.1.3'
gem 'haml-rails', '~> 0.3.4'

gem 'capistrano', '~> 2.9.0'

gem 'therubyracer', '~> 0.9.8'

gem 'jquery-rails', '~> 1.0.16'

gem 'rails3-generators', '~> 0.17.4'

gem 'devise', '~> 1.5.0'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-openid'

group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier',     '~> 1.0.3'

  gem 'zurb-foundation', '~> 2.0.2'
end


group :development do
  gem 'mongrel', '>= 1.2.0.pre2'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'pry'
  gem 'pry-rails'
end


gem 'rspec-rails', :group => [:test, :development]

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'launchy'
  gem 'simplecov', :require => false

  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-bundler'
  gem 'rb-inotify', :require => false

  gem 'mongoid-rspec'
  gem 'database_cleaner'
end
