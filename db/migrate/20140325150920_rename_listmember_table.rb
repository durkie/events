class RenameListmemberTable < ActiveRecord::Migration
  def up
    rename_table :listmembers, :volunteers
    add_column :volunteers, :terms_agreed, :boolean
  end

  def down
  end
end
