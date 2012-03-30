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
    point_dates = %w(a -1 2333-23-123 23323-2-23 23-23-53 2323-234-1 #&=)
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

end
