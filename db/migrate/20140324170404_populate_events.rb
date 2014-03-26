class PopulateEvents < ActiveRecord::Migration
  def up
    add_column :events, :name, :string
    add_column :events, :location, :string
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
  end

  def down
  end
end
