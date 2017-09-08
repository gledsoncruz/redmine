class HerokuApplicationsController < ApplicationController
  layout 'admin_active_scaffold'
  before_filter :require_admin

  active_scaffold :heroku_application do |conf|
    conf.columns[:account].form_ui = :select
    conf.columns[:repository].form_ui = :select
    conf.list.columns.exclude :created_at, :updated_at
  end
end
