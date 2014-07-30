require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

task :run do
  ruby 'temp_run production'
end

task :dev do
  ruby 'temp_run development'
end
