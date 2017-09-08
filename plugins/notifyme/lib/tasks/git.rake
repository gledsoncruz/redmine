namespace :notifyme do
  namespace :git do
    desc 'Fetch all'
    task :reset, [:repository_id] => :environment do |_t, args|
      if args.repository_id.present?
        [Repository.find(args.repository_id)]
      else
        Repository.where(type: 'Repository::Xitolite')
      end.each do |r|
        Notifyme::Git::Repository.new(r).reset
      end
    end

    desc 'Envia notificações de alterações em repositórios Git'
    task :notify, [:reset] => :environment do |_t, args|
      Repository.where(type: 'Repository::Xitolite').each do |r|
        Notifyme::Git::Repository.new(r).notify(args.reset.present?)
      end
    end
  end
end
