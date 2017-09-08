class CreateRepositoryBranches < ActiveRecord::Migration
  def change
    create_table :repository_branches do |t|
      t.references :repository, index: true, foreign_key: true
      t.string :name
      t.string :revision

      t.timestamps null: false
    end
  end
end
