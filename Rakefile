require "rubygems"
require "rake/testtask"
require "rake/rdoctask"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "lib test"
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

Rake::RDocTask.new do |t|
  t.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end
