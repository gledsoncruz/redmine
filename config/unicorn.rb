# -*- encoding : utf-8 -*-
root = "/home/deployer/apps/redmine"
working_directory root
pid "#{root}/tmp/pids/unicorn_redmine.pid"
stderr_path "#{root}/log/unicorn_redmine.log"
stdout_path "#{root}/log/unicorn_redmine.log"

listen "/tmp/unicorn.redmine.sock"
worker_processes 2
timeout 300
