#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'production'

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exist?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, 'config', 'environment')

DaemonRunner.new(__FILE__).run do
  Delayed::Worker.new(:exit_on_complete => true).start
end
