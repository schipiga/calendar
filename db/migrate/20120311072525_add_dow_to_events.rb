class AddDowToEvents < ActiveRecord::Migration
  def up
    add_column :events, :dow, :integer
  end

  def down
    remove_column :events, :dow
  end
end
