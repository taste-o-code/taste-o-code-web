unless Rails.env.production?
  desc 'Run tests coverage with simplecov'
  RSpec::Core::RakeTask.new(:scov) do |t|
    ENV['SCOV'] = "true"
    t.spec_opts = ['--no-drb']

    puts 'Cleaning up coverage reports'
    rm_rf 'coverage'
  end
end
