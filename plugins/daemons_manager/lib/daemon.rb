class Daemon
  class << self
    def all
      @all ||= Daemons::Rails::Monitoring.statuses.each_with_index.map do |v, i|
        Daemon.new(v[0], i)
      end
    end

    def find(id)
      all.each do |d|
        return d if d.id == id.to_s
      end
      raise ActiveRecord::RecordNotFound
    end

    def find_by_name(name)
      all.each do |d|
        return d if d.name == name
      end
      raise "Daemon not found (Name: \"#{name}\")"
    end
  end

  def initialize(name, id)
    @controller = Daemons::Rails::Monitoring.controller(name)
    @id = id
  end

  def id
    @id.to_s
  end

  def start
    @controller.start
  end

  def stop
    @controller.stop
  end

  def restart
    stop
    start
  end

  def name
    @controller.app_name
  end

  def running
    @controller.status == :running
  end

  def log_file
    "#{Rails.root}/log/#{@controller.app_name}.log"
  end

  def autostart
    return false unless configuration
    configuration.autostart
  end

  def sleep_time
    return 60 unless configuration
    configuration.sleep_time
  end

  def to_s
    id
  end

  private

  def configuration
    return false unless ActiveRecord::Base.connection.table_exists? DaemonConfiguration.table_name
    DaemonConfiguration.find_by(daemon: name)
  end
end
