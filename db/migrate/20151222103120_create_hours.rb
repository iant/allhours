class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.integer :user_id
      t.string :client
      t.string :project
      t.date :date
      t.float :hours

      t.timestamps null: false
    end
  end
end
