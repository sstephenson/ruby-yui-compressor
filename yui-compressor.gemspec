Gem::Specification.new do |s|
  s.name = "yui-compressor"
  s.version = "0.9.6"
  s.date = "2011-03-30"
  s.summary = "JavaScript and CSS minification library"
  s.email = "sstephenson@gmail.com"
  s.description = "A Ruby interface to YUI Compressor for minifying JavaScript and CSS assets."
  s.homepage = "http://github.com/sstephenson/ruby-yui-compressor/"
  s.rubyforge_project = "yui"
  s.authors = ["Sam Stephenson"]
  s.files = Dir["Rakefile", "lib/**/*", "test/**/*"]
  s.test_files = Dir["test/*_test.rb"] unless $SAFE > 0
  s.add_dependency "POpen4", ">= 0.1.4"
end
