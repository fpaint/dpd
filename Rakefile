require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:dpd_spec) do |spec|
  spec.pattern = "#{__dir__}/spec/*_spec.rb"
end 

task :default => :dpd_spec
