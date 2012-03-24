class Event < ActiveRecord::Base

  belongs_to :user

  attr_accessor :is_cycle
  attr_accessible :title, :description, :point_date, :is_share, :is_cycle,
                  :cycle, :user_id, :dow

  date_regex = /\A\d{4}-\d{1,2}-\d{1,2}/

  validates :title, :presence => true,
                    :length => { :maximum => 50 }
#  validates :description, :length => { :maximum => 500 }
#  validates :point_date,
#                         :format => { :with => date_regex }
#  validates :is_share, :presence => true,
#                       :inclusion => { :in => %w[0 1] }
#  validates :cycle, :inclusion => { :in => %w[ daily weekly monthly yearly] }
#  validates :user_id, :presence => true, :format => { :with => /\A\d+/ }
  
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
