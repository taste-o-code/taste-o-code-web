desc 'Run tests coverage with simplecov'
Spec::Rake::SpecTask.new(:scov) do |t|
  ENV['SCOV'] = "true"
  t.spec_opts = ['--no-drb', '--format doc']

  puts 'Cleaning up coverage reports'
  rm_rf 'coverage'
end
