require 'rubygems'
require 'bundler'

Bundler.require

##############################
# Configuration

def lib
  "STATSD"
end

MAJOR, MINOR, PATCH = 0, 1, 0

def version
  "#{MAJOR}.#{MINOR}.#{PATCH}"
end

def swc
  "#{lib.downcase.gsub(' ','-')}-#{version}.swc"
end

##############################
# SWC

acompc "bin/#{swc}" do |t|
  t.load_config << 'src/StatsD-config.xml'
  t.debug = true
end

desc "Compile the SWC library file"
task :swc => "bin/#{swc}"

##############################
# Unit Tests

# Compile the unit test swf
amxmlc "bin/StatsDRunner.swf" do |t|
  t.input = 'test/StatsDRunner.mxml'
  t.library_path << 'lib'
  t.source_path << 'test' << 'src'
  t.debug = true
end

task :generate_focused_tests do
  `fu-suite`
end

task :generate_tests do
  `sprout-suite -f`
end

task :setup_test_application_descriptor do
  cp 'test/StatsDRunner-app.xml', 'bin'
end

# Run the test swf using adl
adl 'run-tests' do |t|
  t.app_desc = "bin/StatsDRunner-app.xml"
end

desc "Compile and run the unit tests"
task :unit => [:clean, "bin/StatsDRunner.swf", :setup_test_application_descriptor, 'run-tests']

desc "Compile and run the test swf"
task :test => [:generate_tests, :unit]

desc "Only run tests on changed files"
task :t => [:generate_focused_tests, :unit]

##############################
# Headers

headers do |t|
  t.copyright = 'Copyright MMXIII The orginal author or authors.'
end

manifest do |t|
  t.output = 'src/StatsD-manifest.xml'
  t.filter = 'org.helvector.statsd'
end

##############################
# Tag and Release

desc "Tag v#{version} of the #{lib} library prior to release"
task :tag do
  if `git status` =~ /Changes (not staged for commit|to be committed)/
    puts "You have changes that should be committed before tagging"
    exit!
  end

  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to create a tag!"
    exit!
  end

  print "\nAre you sure you want to tag #{lib} #{version}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0

  sh "git commit --allow-empty -a -m 'v#{version}'"
  sh "git tag v#{version} -m 'Release tag for v#{version} created on #{Date.today.strftime("%d/%m/%y")}'"
  sh "git push origin master"
  sh "git push origin v#{version}"
end

task :default => [ :clean, :test, :swc ]
