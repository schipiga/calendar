class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.date :point_date
      t.boolean :is_share
      t.string :cycle
      t.integer :user_id

      t.timestamps
    end
  end
end
