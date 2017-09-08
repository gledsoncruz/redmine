class CreateHerokuAccounts < ActiveRecord::Migration
  def change
    create_table :heroku_accounts do |t|
      t.string :username
      t.string :password

      t.timestamps null: false
    end
  end
end
