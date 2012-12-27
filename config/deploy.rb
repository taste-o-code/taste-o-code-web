require "rvm/capistrano"
require "bundler/capistrano"

set :application, "Taste-o-Code"
set :deploy_to, "/home/toc/apps/toc/"

set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "toc", :app, :web, :db, :primary => true
set :user, "toc"
set :environment, "production"

set :scm, :git
set :repository, "git@github.com:taste-o-code/taste-o-code-web.git"
set :branch, :production

set :deploy_via, :remote_cache

set :normalize_asset_timestamps, false

namespace :deploy do
  desc "Restart with restart.txt"
  task :restart, :roles => [:app] do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  desc "Symlink config files"
  task :symlink_configs, :roles => :app do
    %w[mongoid.yml omniauth.yml email.yml resque.yml].each do |f|
      run "ln -sf #{shared_path}/config/#{f} #{current_release}/config/#{f}"
    end
  end

  desc "Restart workers"
  task :restart_workers, :roles => :app  do
    run "cd #{current_path} && /usr/bin/env bundle exec rake resque:restart RAILS_ENV=production"
  end
end


after "deploy:finalize_update", "deploy:symlink_configs"
after "deploy", "deploy:cleanup"
after "deploy:create_symlink", "deploy:restart_workers"
after "deploy:rollback", "deploy:restart_workers"
