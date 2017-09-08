# coding: utf-8

require 'redmine'

require 'heroku/patches/repository_patch'

Redmine::Plugin.register :heroku do
  name 'Heroku'
  author 'Eduardo Henrique Bogoni'
  description ''
  version '0.1.0'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :heroku_accounts, { controller: 'heroku_accounts', action: 'index' },
              caption: :label_heroku_accounts
    menu.push :heroku_applications, { controller: 'heroku_applications', action: 'index' },
              caption: :label_heroku_applications
  end
end

Rails.configuration.to_prepare do
  EventsManager.add_listener(Repository, :receive, 'Heroku::Listeners::Repository::Receive')
end
