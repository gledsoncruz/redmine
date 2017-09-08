namespace :notifyme do
  namespace :events do
    namespace :issue do
      desc 'Envia notificações da criação de um Issue'
      task :create, [:issue_id] => :environment do |_t, args|
        Notifyme::Events::Issue::Create.new(
          EventsManager::Event.new(Issue, :create, Issue.find(args.issue_id))
        ).run
      end

      desc 'Envia notificações da alteração de um Issue'
      task :update, [:journal_id] => :environment do |_t, args|
        Notifyme::Events::Issue::Update.new(
          EventsManager::Event.new(Issue, :update, Journal.find(args.journal_id))
        ).run
      end
    end

    namespace :time_entry do
      desc 'Envia notificações da criação de um TimeEntry'
      task :create, [:time_entry_id] => :environment do |_t, args|
        Notifyme::Events::TimeEntry::Create.new(
          EventsManager::Event.new(TimeEntry, :create, TimeEntry.find(args.time_entry_id))
        ).run
      end

      desc 'Envia notificações da remoção de um TimeEntry'
      task :delete, [:time_entry_id] => :environment do |_t, args|
        Notifyme::Events::TimeEntry::Delete.new(
          EventsManager::Event.new(
            TimeEntry, :delete, EventsManager::RemovedRecord.new(TimeEntry.find(args.time_entry_id))
          )
        ).run
      end
    end
  end
end
