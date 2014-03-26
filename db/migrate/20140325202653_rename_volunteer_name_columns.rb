class RenameVolunteerNameColumns < ActiveRecord::Migration
  def up
    rename_column :volunteers, :name, :first_name
    add_column :volunteers, :last_name, :string
  end

  def down
  end
end
