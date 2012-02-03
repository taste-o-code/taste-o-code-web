require 'resque/tasks'

LOG = Rails.root.to_s + "/log/resque_worker.log"

namespace :resque do

  desc "Setup resque"
  task :setup => :environment do
    Resque.redis = Rails.configuration.resque[:redis_resque]
  end

  desc "Stop all resque workers processing."
  task :stop => :setup do
    workers = Resque.workers
    puts "Killing workers: #{ workers }"
    pids = workers.map(&:pid)

    `kill -s QUIT #{pids.join(' ')}` unless pids.empty?
  end

  desc "Start one resque worker in background"
  task :start => :environment do
    queue = Rails.configuration.resque[:queue_resque]
    cmd = "QUEUE='#{ queue }' nohup rake resque:work"
    puts cmd
    `sh -c '#{ cmd } > #{ LOG } &'`
  end

  desc "Restart worker: stops all workers and starts 1 worker."
  task :restart => [:stop, :start]

end

