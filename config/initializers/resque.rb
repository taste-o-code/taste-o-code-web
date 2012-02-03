Rails.configuration.resque = {
  :redis_resque => 'localhost:6379',
  :redis_pyres => 'localhost:6380',
  :queue_resque => 'submission_results',
  :queue_pyres => 'submissions',
  :worker_pyres => 'worker.SubmissionChecker'
}

# Use :redis_pyres because rails app enqueues jobs for pyres.
# So it need to use redis for pyres.
Resque.redis = Rails.configuration.resque[:redis_pyres]
