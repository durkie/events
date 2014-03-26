class Checkin < ActiveRecord::Base
  attr_accessible :event_id, :volunteer_id

  belongs_to :event
  belongs_to :volunteer
end
