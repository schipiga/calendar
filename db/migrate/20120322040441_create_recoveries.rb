class CreateRecoveries < ActiveRecord::Migration
  def change
    create_table :recoveries do |t|
      t.string :key
      t.integer :user_id

      t.timestamps
    end
  end
end
