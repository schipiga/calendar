class Recovery < ActiveRecord::Base

  belongs_to :user

  attr_accessible :key, :user_id

end
