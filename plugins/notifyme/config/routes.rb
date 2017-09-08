RedmineApp::Application.routes.draw do
  resources(:telegram_chats) { as_routes }
  get '/my/telegram', to: 'my_telegram#index', as: 'my_telegram'
  put '/my/telegram', to: 'my_telegram#update'
end
