class Event < ActiveRecord::Base

  belongs_to :user

  attr_accessor :is_cycle
  attr_accessible :title, :description, :point_date, :is_share, :is_cycle,
                  :cycle, :user_id, :dow

  date_regex = /\A\d{4}-\d{1,2}-\d{1,2}/

  validates :title, :presence => true,
                    :length => { :maximum => 50 }
  validates :description, :length => { :maximum => 500 }
  validates :point_date, :presence => true,
                         :format => { :with => date_regex }
  #  validates :is_share, :inclusion => { :in => %w(0 1) }
  #  validates :cycle, :inclusion => { :in => %w( daily weekly monthly yearly) }
  validates :user_id, :presence => true, :format => { :with => /\A\d+/ }
  
  before_save :set_cycle, :set_dow

  
  # return events list for current date
  def self.events_in_day(date)
    date = Date.parse(date)

    events = select('id, title').where('point_date = ?', date)

    request = 'point_date < ? AND cycle = "daily"'
    events += select('id, title').where(request, date)

    request = 'point_date < ? AND cycle = "weekly" AND dow = ?'
    events += select('id, title').where(request, date, date.wday)
    
    request = 'point_date < ? AND cycle = "monthly" AND point_date LIKE ?'
    events += select('id, title').where(request, date, '%-%-' + date.day.to_s)

    request = 'point_date < ? AND cycle = "yearly" AND point_date LIKE ?'
    events += select('id, title').where(request,
                                        date,
                                        '%-' + date.month.to_s +
                                        '-' + date.day.to_s)

    return events
  end
  
  # return events count for days of month, real magic :)
  def self.events_in_month(month, year)
    
    month = month.to_i
    year = year.to_i

    # the first, select onetime events
    list_once = {}
    request = 'point_date <= ? AND point_date >= ? AND cycle = ""'
    events = select('point_date').where(request,
                                        Date.civil(year, month, -1),
                                        Date.civil(year, month, 1))
    
    # calculate counts
    events.each { |e|
      if list_once[e['point_date'].day].nil?
        list_once[e['point_date'].day] = 1
      else
        list_once[e['point_date'].day] += 1
      end
    }
    
    # later, select period events
    list_period = {}
    1.upto(Date.civil(year, month, -1).day) { |i|
      list_period[i] = 0
    }

    request = 'point_date <= ? AND cycle <> ""' 
    events = select('point_date, cycle, dow').where(request,
                                                    Date.civil(year, month, -1))
    
    # sort periodical events, depending form period type
    events.each { |e|
      case e['cycle']
      when 'daily'
        list_period.each { |key, value|
          if Date.civil(year, month, key) >= e['point_date']
            list_period[key] += 1
          end
        }

      when 'weekly'
        list_period.each { |key, value|
          if Date.civil(year, month, key).wday == e['dow']
            if Date.civil(year, month, key) >= e['point_date']
              list_period[key] += 1
            end
          end
        }

      when 'monthly'
        if Date.civil(year, month, -1) > e['point_date']
          list_period[e['point_date'].day] += 1
        end
         
      when 'yearly'
        if e['point_date'].month == month
          list_period[e['point_date'].day] +=1
        end
      end
    }
    
    # sum period and onetime events
    events = []
    i = 0
    list_period.each { |key, value|
      if !list_once[key].nil?
        value += list_once[key]
      end
      if value != 0
        events[i] = {}
        events[i]['day'] = key
        events[i]['count'] = value
        i += 1
      end
    }

    return events
  end

  private

    def set_cycle
      if is_cycle == '0' 
        self.cycle = ''
      end
    end
    
    # calculate day of week
    def set_dow
      self.dow = Date.parse(point_date.to_s).wday
    end
end
