class AddListMemberAttributes < ActiveRecord::Migration
  def up
    add_column :listmembers, :name, :string
    add_column :listmembers, :email, :string
  end

  def down
  end
end
