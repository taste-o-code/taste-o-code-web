# Monkey patch Worker class, so it doesn't delete pyres's workers from redis.
module Resque
  class Worker

    def prune_dead_workers
      all_workers = Worker.all
      pids = all_pids unless all_workers.empty?
      all_workers.each do |worker|
        host, pid, queues = worker.id.split(':')
        next unless host == hostname
        next if pids.include?(pid)
        log! "Pruning dead worker: #{worker}"
        worker.unregister_worker
      end
    end

    def all_pids
      `ps -A -o pid`.split("\n").map(&:strip)
    end
  end
end

Rails.configuration.resque = YAML.load_file("#{Rails.root.to_s}/config/resque.yml").symbolize_keys
