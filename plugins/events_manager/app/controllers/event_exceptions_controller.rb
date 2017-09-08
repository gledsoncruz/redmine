class EventExceptionsController < ApplicationController
  before_action :require_admin
  layout 'admin_active_scaffold'
  before_action :clear_event_exception_unchecked, only: :index

  active_scaffold :event_exception do |conf|
    conf.actions.exclude :create, :update, :delete
    conf.list.columns = [:created_at, :event_entity, :event_action, :listener_class]
    conf.list.sorting = { created_at: :desc }
    conf.action_links.add :download, type: :member, label: 'Download', page: true
  end

  def download
    ex = find_if_allowed(params[:id], :read)
    send_data ex.attributes.to_yaml, filename: download_filename(ex)
  end

  private

  def download_filename(ex)
    [Setting.host_name, 'exception', ex.id.to_s, ex.created_at.to_s].map do |s|
      s.parameterize.strip
    end.select(&:present?).join('_')
  end

  def clear_event_exception_unchecked
    EventsManager::Settings.event_exception_unchecked = false if
    EventsManager::Settings.event_exception_unchecked
  end
end
