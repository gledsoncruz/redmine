# encoding: UTF-8

def children_directories(path)
  Dir.entries(path).select do |e|
    File.directory?(File.join(path, e)) && !(e == '.' || e == '..')
  end
end

def eac_plugins
  children_directories(File.expand_path('../../../..', __FILE__)) -
    %w(redmine_bootstrap_kit redmine_git_hosting)
end

namespace :eac_base do
  Rake::TestTask.new(test: 'db:test:prepare') do |t|
    t.description = 'Executa testes de interesse da E.A.C..'
    t.libs << 'test'
    t.test_files = eac_plugins.map { |p| "plugins/#{p}/test/**/*_test.rb" }
    t.verbose = true
  end
end
