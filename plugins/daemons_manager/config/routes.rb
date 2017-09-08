RedmineApp::Application.routes.draw do
  get '/daemons', to: 'daemons#index', as: 'daemons'
  get '/daemons/:id/start', to: 'daemons#start', as: 'start_daemon'
  get '/daemons/:id/stop', to: 'daemons#stop', as: 'stop_daemon'
  get '/daemons/:id/restart', to: 'daemons#restart', as: 'restart_daemon'
  get '/daemons/:id/log', to: 'daemons#log', as: 'log_daemon'
  resources(:daemon_configurations) { as_routes }
end
