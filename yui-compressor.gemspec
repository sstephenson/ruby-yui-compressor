Gem::Specification.new do |s|
  s.name = "yui-compressor"
  s.version = "0.9.2"
  s.date = "2009-10-16"
  s.summary = "JavaScript and CSS minification library"
  s.email = "sstephenson@gmail.com"
  s.description = "A Ruby interface to YUI Compressor for minifying JavaScript and CSS assets."
  s.homepage = "http://github.com/sstephenson/ruby-yui-compressor/"
  s.rubyforge_project = "yui"
  s.has_rdoc = true
  s.authors = ["Sam Stephenson"]
  s.files = Dir["Rakefile", "lib/**/*", "test/**/*"]
  s.test_files = Dir["test/*_test.rb"] unless $SAFE > 0
end
