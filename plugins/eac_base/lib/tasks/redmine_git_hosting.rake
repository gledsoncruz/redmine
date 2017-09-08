namespace :redmine_git_hosting do
  desc 'Executa as operações de "Rescue" da configuração do plugin RedmineGitHosting'
  task rescue: :environment do |_t, _args|
    RedmineGitHosting::GitoliteAccessor.update_projects(
      'all',
      message: 'Forced resync of all projects (active, closed, archived)...',
      force: true
    )
    RedmineGitHosting::GitoliteAccessor.resync_ssh_keys
    RedmineGitHosting::GitoliteAccessor.flush_git_cache
  end
end
