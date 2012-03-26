require 'spec_helper'

describe "Sessions" do

  describe "sign_in" do

    describe "success" do

      it 'should enter to private office' do
        visit root_path
        fill_in "session[email]",      :with => 'sportsedrik@mail.ru'
        fill_in "session[password]",   :with => 'sedrik'
        click_button  
        response.should render_template('new')
      end

    end

  end

end
