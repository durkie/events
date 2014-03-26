class CreateListmembers < ActiveRecord::Migration
  def change
    create_table :listmembers do |t|

      t.timestamps
    end
  end
end
