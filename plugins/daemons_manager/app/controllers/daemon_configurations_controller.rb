class DaemonConfigurationsController < ApplicationController
  before_action :require_admin
  layout 'admin_active_scaffold'

  active_scaffold :daemon_configuration do |conf|
    conf.columns[:daemon].options = { options: DaemonConfiguration.daemons.map { |n| [n, n] } }
    conf.columns[:daemon].form_ui = :select
  end
end
