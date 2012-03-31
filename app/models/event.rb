class Event < ActiveRecord::Base

  belongs_to :user

  attr_accessor :is_periodical
  attr_accessible :title, :description, :point_date, :is_share, :is_periodical,
                  :periodical, :user_id, :day_of_week

  date_regex = /\A\d+-\d{1,2}-\d{1,2}/

  validates :title, :presence => { :message => 'et01'},
                    :length => { :maximum => 50, :message => 'et02' }
  validates :description, :length => { :maximum => 500, :message => 'ed01' }
  validates :point_date, :presence => { :message => 'ep01' },
                         :format => { :with => date_regex, :message => 'ep02' }
  validates :is_share, :numericality => { :only_integer => true,
                                          :greater_than => -1,
                                          :less_than => 2 }
  validates :periodical, :inclusion => { :in => %w(none daily weekly monthly yearly) }
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  
  before_validation :set_periodical
  before_save :set_day_of_week

  
  # return events list for current date
  def self.events_in_day(date)
    begin
      date = Date.parse(date)
      request_events_in_day(date)
    rescue
      return 'Invalid data format'
    end
  end
  
  # return events count for days of month, real magic :)
  def self.events_in_month(month, year)

    month = month.to_i

    if month < 1 or month > 12 
      return 'Invalid month format'
    end

    year = year.to_i

    if year < 1 
      return 'Invalid year format'
    end

    return merge_events(request_once_events(month, year),
                       request_periodical_events(month, year))
  end

  private
    
    # force set periodical, if it wasn't sent
    def set_periodical
      if is_periodical == '0' 
        self.periodical = 'none'
      end
    end
    
    # calculate day of week
    def set_day_of_week
      self.day_of_week = Date.parse(point_date.to_s).wday
    end
    
    # get events for day
    def self.request_events_in_day(date)
      events = select('id, title').where('point_date = ?', date)

      request = 'point_date < ? AND periodical = "daily"'
      events += select('id, title').where(request, date)

      request = 'point_date < ? AND periodical = "weekly" AND day_of_week = ?'
      events += select('id, title').where(request, date, date.wday)
    
      request = 'point_date < ? AND periodical = "monthly" AND point_date LIKE ?'
      events += select('id, title').where(request, date, '%-%-' + ('%02d' % date.day))

      request = 'point_date < ? AND periodical = "yearly" AND point_date LIKE ?'
      events += select('id, title').where(request,
                                          date,
                                          '%-' + ('%02d' % date.month) +
                                          '-' + ('%02d' % date.day.to_s))
    end

    # get and sort onetime events
    def self.request_once_events(month, year)
      request = 'point_date <= ? AND point_date >= ? AND periodical = "none"'
      events = select('point_date').where(request,
                                        Date.civil(year, month, -1),
                                        Date.civil(year, month, 1))
    
      result = {}
      events.each { |e|
        if result[e.point_date.day].nil?
          result[e.point_date.day] = 1
        else
          result[e.point_date.day] += 1
        end
      }
      return result 
    end

    # get and sort periodical events
    def self.request_periodical_events(month, year)
      request = 'point_date <= ? AND periodical <> "none"' 
      events = select('point_date, periodical, day_of_week').
                  where(request, Date.civil(year, month, -1))
      
      # later, select period events
      result = {}
      1.upto(Date.civil(year, month, -1).day) { |i| result[i] = 0 }

      # sort periodical events, depending form period type
      events.each { |e|
        case e['periodical']
        when 'daily'
          result.each { |key, value|
            if Date.civil(year, month, key) >= e['point_date']
              result[key] += 1
            end
          }

        when 'weekly'
          result.each { |key, value|
            if Date.civil(year, month, key).wday == e['day_of_week']
              if Date.civil(year, month, key) >= e['point_date']
                result[key] += 1
              end
            end
          }

        when 'monthly'
          if Date.civil(year, month, -1) >= e['point_date']
            result[e['point_date'].day] += 1
          end
         
        when 'yearly'
          if e['point_date'].month == month
            result[e['point_date'].day] +=1
          end
        end
      }

      return result
    end

    # merge onetime and periodal events
    def self.merge_events(once, period)
      result = []
      
      i = 0
      
      period.each { |key, value|
        if !once[key].nil?
          value += once[key]
        end
        if value != 0
          result[i] = {}
          result[i]['day'] = key
          result[i]['count'] = value
          i += 1
        end
      }

      return result
    end
end
