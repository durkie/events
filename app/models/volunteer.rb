class Volunteer < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :terms_agreed, :wants_to_join_mailing_list

  has_many :checkins
end
