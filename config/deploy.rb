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
    %w[mongoid.yml omniauth.yml email.yml].each do |f|
      run "ln -sf #{shared_path}/config/#{f} #{current_release}/config/#{f}"
    end
  end

end


after "deploy:finalize_update", "deploy:symlink_configs"
after "deploy", "deploy:cleanup"
