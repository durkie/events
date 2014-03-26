class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer "event_id"
      t.integer "volunteer_id"
      t.timestamps
    end
  end
end
