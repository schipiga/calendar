class AddDowToEvents < ActiveRecord::Migration
  def up
    add_column :events, :day_of_week, :integer
  end

  def down
    remove_column :events, :day_of_week
  end
end
