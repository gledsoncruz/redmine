class DaemonsController < ApplicationController
  before_action :require_admin
  layout 'admin'

  def index
    @daemons = Daemon.all
  end

  def start
    daemon_action(:start, 'Daemon inicializado')
  end

  def stop
    daemon_action(:stop, 'Daemon parado')
  end

  def restart
    daemon_action(:restart, 'Daemon reiniciado')
  end

  def log
    @daemon = Daemon.find(params[:id])
    @log = nil
    @log = File.read(@daemon.log_file) if File.exist?(@daemon.log_file)
  rescue ActiveRecord::RecordNotFound
    redirect_to daemons_url, notice: "Daemon não encontrado com o ID=#{params[:id]}"
  end

  private

  def daemon_action(method, success_message)
    @daemon = Daemon.find(params[:id])
    @daemon.send(method)
    redirect_to daemons_url, notice: success_message
  rescue ActiveRecord::RecordNotFound
    redirect_to daemons_url, notice: "Daemon não encontrado com o ID=#{params[:id]}"
  end
end
