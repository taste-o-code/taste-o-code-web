desc 'Run tests coverage with simplecov'
Spec::Rake::SpecTask.new(:scov) do |t|
  ENV['SCOV'] = "true"
  t.spec_opts = ['--no-drb']

  puts 'Cleaning up coverage reports'
  rm_rf 'coverage'
end
