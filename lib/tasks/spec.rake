unless Rails.env.production?
  require 'launchy'

  desc 'Run tests coverage with simplecov'
  task :scov => [:set_scov_env, :spec_without_drb] do
    Launchy.open 'coverage/index.html'
  end

  desc 'Run specs with --no-drb option'
  RSpec::Core::RakeTask.new(:spec_without_drb) do |t|
    t.spec_opts = ['--no-drb']
  end

  desc 'Remove coverage reports and set SCOV env variable to true'
  task :set_scov_env do
    puts 'Cleaning up coverage reports'
    rm_rf 'coverage'
    ENV['SCOV'] = "true"
  end
end
