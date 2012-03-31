require 'spec_helper'

describe Event do

  before(:each) do
    @event_attr = {
      :title => 'Class meeting',
      :description => 'Our class meeting in cafe "Versaj"',
      :point_date => '2012-03-15',
      :is_share => '1',
      :is_periodical => '1',
      :periodical => 'daily',
    }
    @user_attr = {
      :fio => 'Chipiga Serghey',
      :email => 'sportsedrik@mail.ru',
      :password => 'DoberMan',
      :password_confirmation => 'DoberMan'
    }
    @user = User.create!(@user_attr)
  end

  it 'should create a new instance given valid attributes' do
    @user.events.create!(@event_attr)
  end

  it 'should require title' do
    no_title_event = @user.events.new(@event_attr.merge(:title => ''))
    no_title_event.should_not be_valid
  end

  it 'should refuse a long title' do
    long = 'x' * 51
    long_title_event = @user.events.new(@event_attr.merge(:title => long))
    long_title_event.should_not be_valid
  end

  it 'should not require description' do
    no_description_event = @user.events.new(@event_attr.
                                              merge(:description => ''))
    no_description_event.should be_valid
  end

  it 'should refuse a long description' do
    long = 'Z' * 501
    long_description_event = @user.events.new(@event_attr.
                                                merge(:description => long))
    long_description_event.should_not be_valid
  end

  it 'should require a point date' do
    no_point_date_event = @user.events.new(@event_attr.
                                            merge(:point_date => ''))
    no_point_date_event.should_not be_valid
  end

  it 'should refuse invalid point_date' do
    point_dates = %w(a -1 2333-23-123 23323-232-23 23-2i3-53 2323-234-1 #&=)
    point_dates.each { |point_date|
      invalid_point_date_event = @user.events.new(
                                  @event_attr.merge(:point_date => point_date))
      invalid_point_date_event.should_not be_valid
    }
  end

  it 'should refuse invalid is_share' do
    is_shares = %w(a -1 2 #?)
    is_shares.each { |is_share|
      invalid_is_share_event = @user.events.new(
                                @event_attr.merge(:is_share => is_share))
      invalid_is_share_event.should_not be_valid
    }
  end

  it 'should refuse invalid periodical' do
    periodicals = %w(asdf -13 % &#@ None DaIly weeK asdfsdf-2)
    periodicals.each { |periodical|
      invalid_periodical_event = @user.events.new(
                                  @event_attr.merge(:periodical => periodical))
      invalid_periodical_event.should_not be_valid
    }
  end

  it 'should accept valid periodical' do
    periodicals = %w(none daily weekly monthly yearly)
    periodicals.each { |periodical|
      valid_periodical_event = @user.events.new(
                                @event_attr.merge(:periodical => periodical))
      valid_periodical_event.should be_valid
    }
  end

  describe 'events_in_day method' do
    
    before(:each) do
      @event_attr = {
        :title => 'Class meeting',
        :description => 'Our class meeting in cafe "Versaj"',
        :point_date => '2012-03-15',
        :is_share => '1',
        :is_periodical => '0'
      }
      @expect = '[{"id":1,"title":"Class meeting"}]'
    end
    
    it 'should return current event for current day' do
      @user.events.create!(@event_attr)
      result = @user.events.events_in_day('2012-03-15').to_json
      result.should == @expect
    end
  
    it 'should not return past event for current day' do
      @expect = '[]'
      @user.events.create!(@event_attr)
      result = @user.events.events_in_day('2012-03-16').to_json
      result.should == @expect
    end

    it 'should not return future event for current day' do
      @expect = '[]'
      @user.events.create!(@event_attr)
      result = @user.events.events_in_day('2012-03-14').to_json
      result.should == @expect
    end

    it 'should return past daily event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'daily'))
      result = @user.events.events_in_day('2012-03-16').to_json
      result.should == @expect
    end

    it 'should return current daily event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'daily'))
      result = @user.events.events_in_day('2012-03-15').to_json
      result.should == @expect
    end

    it 'should not return future daily event for current day' do
      @expect = '[]'
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'daily'))
      result = @user.events.events_in_day('2012-03-14').to_json
      result.should == @expect
    end

    it 'should return past weekly event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'weekly'))
      result = @user.events.events_in_day('2012-03-22').to_json
      result.should == @expect
    end

    it 'should return current weekly event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'weekly'))
      result = @user.events.events_in_day('2012-03-15').to_json
      result.should == @expect
    end

    it 'should not return future weekly event for current day' do
      @expect = '[]'
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'weekly'))
      result = @user.events.events_in_day('2012-03-08').to_json
      result.should == @expect
    end

    it 'should return past monthly event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'monthly'))
      result = @user.events.events_in_day('2012-04-15').to_json
      result.should == @expect
    end

    it 'should return current monthly event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'monthly'))
      result = @user.events.events_in_day('2012-03-15').to_json
      result.should == @expect
    end

    it 'should not return future monthly event for current day' do
      @expect = '[]'
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'monthly'))
      result = @user.events.events_in_day('2012-02-15').to_json
      result.should == @expect
    end

    it 'should return past yearly event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'yearly'))
      result = @user.events.events_in_day('2013-03-15').to_json
      result.should == @expect
    end

    it 'should return current yearly event for current day' do
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'yearly'))
      result = @user.events.events_in_day('2012-03-15').to_json
      result.should == @expect
    end

    it 'should not return future yearly event for current day' do
      @expect = '[]'
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'yearly'))
      result = @user.events.events_in_day('2011-03-15').to_json
      result.should == @expect
    end

    it 'should return all events for current day' do
      count = 10
      @expect = 5 * count 
      count.times { 
        @user.events.create!(@event_attr)
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'daily'))
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'weekly'))
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'monthly'))
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'yearly'))
      }
        result = @user.events.events_in_day('2012-03-15')
        result.count.should == @expect
    end

    it 'should know invalid data' do
      @expect = 'Invalid data format'
      @user.events.create!(@event_attr)
      result = @user.events.events_in_day('2012-0x3-15')
      result.should == @expect
    end

  end

  describe 'events_in_month method' do
    
    before(:each) do
      @event_attr = {
        :title => 'Class meeting',
        :description => 'Our class meeting in cafe "Versaj"',
        :point_date => '2012-3-1',
        :is_share => '1',
        :is_periodical => '0'
      }
    end
  
    it 'should return current events for current month' do
      expect = []
      i = 0
      count = 5
      
      [1, 15, 31].each { |day|
        expect[i] = { :day => day, :count => count }
        i += 1
      }

      count.times {
        @user.events.create!(@event_attr)
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-15'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-31'))
      }
      result = @user.events.events_in_month(3, 2012).to_json
      result.should == expect.to_json
    end

    it 'should not return past event for current month' do
      expect = []
      @user.events.create!(@event_attr)
      result = @user.events.events_in_month(4, 2012).to_json
      result.should == expect.to_json
    end

    it 'should not return future event for current month' do
      expect = []
      @user.events.create!(@event_attr)
      result = @user.events.events_in_month(2, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return current daily events for current month' do
      count = 5
      expect = []
      1.upto(31) { |i| expect[i - 1] = { 'day' => i, 'count' => count } }
      15.upto(31) { |i| expect[i - 1]['count'] += count }
      expect[30]['count'] += count

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'daily'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-15',
                                               :is_periodical => 1,
                                               :periodical => 'daily'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-31',
                                               :is_periodical => 1,
                                               :periodical => 'daily'))
      }
      result = @user.events.events_in_month(3, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return past daily event for current month' do
      count = 5
      expect = []
      1.upto(30) { |i| expect[i - 1] = { 'day' => i, 'count' => count } }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'daily'))
      }
      result = @user.events.events_in_month(4, 2012).to_json
      result.should == expect.to_json
    end

    it 'should not return future daily event for current month' do
      expect = []
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'daily'))
      result = @user.events.events_in_month(2, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return current weekly events for current month' do
      expect = []
      i = 0
      count = 5
      
      [1, 8, 15, 16, 22, 23, 29, 30, 31].each { |day|
        expect[i] = { :day => day, :count => count }
        i += 1
      }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'weekly'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-16',
                                               :is_periodical => 1,
                                               :periodical => 'weekly'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-31',
                                               :is_periodical => 1,
                                               :periodical => 'weekly'))
      }
      result = @user.events.events_in_month(3, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return past weekly events for current month' do
      expect = []
      i = 0
      count = 5
      
      [5, 12, 19, 26].each { |day|
        expect[i] = { :day => day, :count => count }
        i += 1
      }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'weekly'))
      }
      result = @user.events.events_in_month(4, 2012).to_json
      result.should == expect.to_json
    end

    it 'should not return future weekly event for current month' do
      expect = []
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'weekly'))
      result = @user.events.events_in_month(2, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return current monthly events for current month' do
      expect = []
      i = 0
      count = 5
      
      [1, 15, 31].each { |day|
        expect[i] = { :day => day, :count => count }
        i += 1
      }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'monthly'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-15',
                                               :is_periodical => 1,
                                               :periodical => 'monthly'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-31',
                                               :is_periodical => 1,
                                               :periodical => 'monthly'))
      }
      result = @user.events.events_in_month(3, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return past monthly events for current month' do
      expect = []
      count = 5
      
      expect[0] = { :day => 1, :count => count }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'monthly'))
      }
      result = @user.events.events_in_month(4, 2012).to_json
      result.should == expect.to_json
    end

    it 'should not return future monthly event for current month' do
      expect = []
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'monthly'))
      result = @user.events.events_in_month(2, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return current yearly events for current month' do
      expect = []
      i = 0
      count = 5
      
      [1, 15, 31].each { |day|
        expect[i] = { :day => day, :count => count }
        i += 1
      }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'yearly'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-15',
                                               :is_periodical => 1,
                                               :periodical => 'yearly'))
        @user.events.create!(@event_attr.merge(:point_date => '2012-3-31',
                                               :is_periodical => 1,
                                               :periodical => 'yearly'))
      }
      result = @user.events.events_in_month(3, 2012).to_json
      result.should == expect.to_json
    end

    it 'should return past yearly events for current month' do
      expect = []
      count = 5
      
      expect[0] = { :day => 1, :count => count }

      count.times {
        @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                               :periodical => 'yearly'))
      }
      result = @user.events.events_in_month(3, 2013).to_json
      result.should == expect.to_json
    end

    it 'should not return future yearly event for current month' do
      expect = []
      @user.events.create!(@event_attr.merge(:is_periodical => 1,
                                             :periodical => 'yearly'))
      result = @user.events.events_in_month(3, 2011).to_json
      result.should == expect.to_json
    end
    
    it 'should know invalid month' do
      expect = 'Invalid month format'
      months = %w(-1 0 13)
      
      @user.events.create!(@event_attr)
      months.each { |month|
        result = @user.events.events_in_month(month, 2012)
        result.should == expect
      }
    end

    it 'should know invalid year' do
      expect = 'Invalid year format'
      years = %w(-1 0)
      
      @user.events.create!(@event_attr)
      years.each { |year|
        result = @user.events.events_in_month(3, year)
        result.should == expect
      }
    end

  end

end
