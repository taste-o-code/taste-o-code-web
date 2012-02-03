Rails.configuration.resque = YAML.load_file("#{Rails.root.to_s}/config/resque.yml").symbolize_keys

# Use :redis_pyres because rails app enqueues jobs for pyres.
# So it need to use redis for pyres.
Resque.redis = Rails.configuration.resque[:redis_pyres]
