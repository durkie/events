class AddJoinMailingListFieldToVolunteers < ActiveRecord::Migration
  def change
    add_column :volunteers, :wants_to_join_mailing_list, :boolean
  end
end
