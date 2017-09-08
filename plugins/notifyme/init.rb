# coding: utf-8

require 'redmine'

require 'notifyme/patches/repository_patch'
require 'notifyme/patches/user_patch'
require_dependency 'notifyme/hooks/add_my_telegram_link'
require_dependency 'notifyme/hooks/add_assets'

Redmine::Plugin.register :notifyme do
  name 'Notify me'
  author 'Eduardo Henrique Bogoni'
  description 'Notificações'
  version '0.1.0'

  settings(default: {}, partial: 'settings/notifyme')

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :telegram_chats, { controller: 'telegram_chats', action: 'index' },
              caption: :label_telegram_chats
  end
end

Rails.configuration.to_prepare do
  EventsManager.add_listener(Issue, :create, 'Notifyme::Events::Issue::Create')
  EventsManager.add_listener(Issue, :update, 'Notifyme::Events::Issue::Update')
  EventsManager.add_listener(Repository, :receive, 'Notifyme::Events::Repository::Receive')
  EventsManager.add_listener(TimeEntry, :create, 'Notifyme::Events::TimeEntry::Create')
  EventsManager.add_listener(TimeEntry, :delete, 'Notifyme::Events::TimeEntry::Delete')
  EventsManager.add_listener(TimeEntry, :update, 'Notifyme::Events::TimeEntry::Update')
end
