require 'resque/tasks'

task "resque:setup" => :environment

QUEUE = 'submission_results'
LOG = Rails.root.to_s + "/log/resque_worker.log"


namespace :resque do

  desc "Stop all resque workers processing queue '#{ QUEUE }'"
  task :stop do
    workers = Resque.workers.select{ |w| w.queues.include?(QUEUE) }
    puts "Killing workers: #{ workers }"
    pids = workers.map(&:pid)

    `kill -s QUIT #{pids.join(' ')}` unless pids.empty?
  end

  desc "Start one worker on queue '#{QUEUE}' in background"
  task :start do
    cmd = "QUEUE='#{ QUEUE }' nohup rake resque:work"
    puts cmd
    `sh -c '#{ cmd } > #{ LOG } &'`
  end

  desc "Restart worker: stops all workers and starts 1 worker."
  task :restart => [:stop, :start]

end

