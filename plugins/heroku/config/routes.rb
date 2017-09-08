RedmineApp::Application.routes.draw do
  resources(:heroku_accounts) { as_routes }
  resources(:heroku_applications) { as_routes }
end
