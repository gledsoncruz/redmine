namespace :heroku do
  desc 'Instala aplicações Heroku'
  task :deploy, [:app_name] => :environment do |_t, args|
    Heroku::ApplicationDeploy.check_commands
    if args.app_name
      [HerokuApplication.where(name: args.app_name).first!]
    else
      HerokuApplication.all
    end.each do |app|
      Heroku::ApplicationDeploy.new(app).run
    end
  end
end
