class DaemonRunner
  def initialize(daemon_file)
    @daemon_file = File.basename(daemon_file)
  end

  def run
    raise 'Bloco deve ser fornecido' unless block_given?
    init_running
    while $running
      begin
        yield
      rescue StandardError => ex
        Rails.logger.warn ex
      end
      sleep_phase
    end
  end

  private

  def daemon
    @daemon ||= Daemon.find_by_name(@daemon_file)
  end

  def init_running
    $running = true
    Signal.trap('TERM') do
      $running = false
    end
  end

  def sleep_phase
    Rails.logger.debug "Aguardando #{sleep_time} segundos até a próxima execução"
    sleep sleep_time if $running
  end

  def sleep_time
    daemon.sleep_time
  end
end
