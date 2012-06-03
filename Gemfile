source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'
gem 'rake',  '~> 0.9.2.2'

gem 'mongoid',  '~> 2.4.0'
gem 'mongoid_auto_increment', '~> 0.0.8'
gem 'bson_ext'

gem 'haml',       '~> 3.1.3'
gem 'haml-rails', '~> 0.3.4'

gem 'capistrano', '~> 2.12.0'

gem 'therubyracer', '~> 0.10.1'

gem 'jquery-rails', '~> 2.0.2'
gem 'gritter', '~> 1.0.0'

gem 'kaminari', '~> 0.13.0'

gem 'styx', '~> 0.1.0'
gem 'js-routes', '~> 0.8.0'

gem 'rails3-generators', '~> 0.17.4'

gem 'resque', '~> 1.19'

gem 'devise', '~> 2.0.4'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-openid'

gem 'redcarpet', '~> 2.1.0'

gem 'activeadmin'

# special versions of activeadmin dependencies
gem 'formtastic',  '< 2.2.0' # https://github.com/gregbell/active_admin/issues/1240
gem 'meta_search', '>= 1.1.0.pre'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '~> 1.2.2'

  gem 'zurb-foundation', '~> 2.2.1'
end

group :development do
  gem 'mongrel', '>= 1.2.0.pre2'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-doc'
end

gem 'rspec-rails', :group => [:test, :development]

group :test do
  gem 'factory_girl_rails', '~> 3.3.0'
  gem 'capybara',           '~> 1.1.2'
  gem 'capybara-webkit',    '~> 0.12.1'
  gem 'launchy'

  gem 'mongoid-rspec'
  gem 'mock_redis'
  gem 'database_cleaner'

  gem 'simplecov', '~> 0.6.4', :require => false
  gem 'fuubar', :require => false

  gem 'guard',         :require => false
  gem 'guard-rspec',   :require => false
  gem 'guard-spork',   :require => false
  gem 'guard-bundler', :require => false
  gem 'rb-inotify',    :require => false
end
