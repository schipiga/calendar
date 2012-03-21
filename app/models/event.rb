class Event < ActiveRecord::Base

  belongs_to :user

  attr_accessor :is_cycle
  attr_accessible :title, :description, :point_date, :is_share, :is_cycle, :cycle, :user_id, :dow

  before_save :set_cycle, :set_dow

  private
    
    def set_cycle
      if is_cycle == '0' 
        self.cycle = ''
      end
    end

    def set_dow
      self.dow = Date.parse(point_date.to_s).wday
    end
end
