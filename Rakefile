require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "integrity-jabber"
    gem.summary = %Q{A jabber notifier for integrity}
    gem.email = "badcarl@gmail.com"
    gem.homepage = "http://github.com/badcarl/integrity-jabber"
    gem.authors = ["Carl Porth"]
    gem.add_dependency 'integrity'
    gem.add_dependency 'xmpp4r'
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new('test:unit') do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/unit/**/*_test.rb'
  test.verbose = true
end

Rake::TestTask.new('test:remote') do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/remote/**/*_test.rb'
  test.verbose = true
end

task :test => 'test:unit'
task :default => :test
