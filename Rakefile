require 'rake/testtask'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test