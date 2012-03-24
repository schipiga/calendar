require 'spec_helper'

describe Event do

  before(:each) do
    @attr = {
      :title => 'Class meeting',
      :description => 'Our class meeting in cafe "Versaj"',
      :point_date => 2012-03-15,
      :is_share => '1',
      :cycle => 'daily',
      :user_id => '1'
    }
  end

  it 'should create a new instance given valid attributes' do
    Event.create!(@attr)
  end

end
