namespace :spec do
  desc 'Run tests coverage with simplecov'
  task :scov => [:scov_env, :spec] do
    require 'launchy'
    Launchy.open 'coverage/index.html'
  end

  task :scov_env do
    puts 'Cleaning up coverage reports'
    rm_rf 'coverage'

    ENV['SCOV']      = 'true'
    ENV['SPEC_OPTS'] = '--no-drb'
  end

  desc 'Run test on CI'
  task :ci => [:ci_env, :spec]

  task :ci_env do
    %w[mongoid.yml omniauth.yml resque.yml].each { |file| `ln -s #{file}.example config/#{file}` }

    ENV['SPEC_OPTS'] = '--no-drb --tag ~ci:skip --format doc'
  end
end
