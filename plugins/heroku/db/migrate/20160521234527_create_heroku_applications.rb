class CreateHerokuApplications < ActiveRecord::Migration
  def change
    create_table :heroku_applications do |t|
      t.string :name
      t.boolean :active, null: false, default: true
      t.belongs_to :account, class_name: 'HerokuAccount'
      t.belongs_to :repository
      t.string :source_branch
      t.string :last_deploy_commit, null: false, default: ''

      t.timestamps null: false
    end
  end
end
