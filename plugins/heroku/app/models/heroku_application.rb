class HerokuApplication < ActiveRecord::Base
  belongs_to :account, class_name: 'HerokuAccount'
  belongs_to :repository

  validates :name, presence: true, uniqueness: true
  validates :source_branch, :repository, :account, presence: true
end
