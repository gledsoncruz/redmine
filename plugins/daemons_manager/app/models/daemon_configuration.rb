class DaemonConfiguration < ActiveRecord::Base
  def self.daemons
    Daemon.all.map(&:name)
  end

  validates :daemon, presence: true, uniqueness: true, inclusion: { in: daemons }
  validates :sleep_time, numericality: { only_integer: true, greater_than_or_equal_to: 1 },
                         allow_nil: true
end
