class HerokuAccount < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  def to_label
    username
  end
end
