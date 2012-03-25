require 'spec_helper'

describe UsersController do
  render_views

  describe 'GET "new"' do

    it 'should be successful' do
      xhr :get, :new
      response.should be_success
    end
 
    it 'should have right fields' do
      xhr :get, :new
      response.should have_selector('input', :name => 'user[fio]')
      response.should have_selector('input', :name => 'user[email]')
      response.should have_selector('input', :name => 'user[password]')
      response.should have_selector('input', :name => 
                                    'user[password_confirmation]')
      response.should have_selector('input', :name => 'commit')
    end
  
  end
  
  describe 'GET "show"' do

    before(:each) do
      @attr = { :fio => 'Ivanov Alex',
                :email => 'ivanov@gmail.com',
                :password => '2jb23jb',
                :password_confirmation => '2jb23jb' }
      @user = User.create!(@attr)
    end

    it 'should be redirect to main' do
      get :show,  :id => @user
      response.should redirect_to root_path
    end

  end

  describe 'POST "create"' do
   
    describe 'failure' do
      
      before(:each) do
        @attr = { :fio => '',
                  :email => '',
                  :password => '',
                  :password_confirmation => '' }
      end

      it 'should not create a user' do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it 'should have correct failure response' do
        post :create, :user => @attr
        response.should render_template(:text => 'Sorry, something is wrong')
      end

    end
    
    describe 'success' do

      before(:each) do
        @attr = { :fio => 'New user',
                  :email => 'user@example.com',
                  :password => 'valid_pswd',
                  :password_confirmation => 'valid_pswd' }
      end

      it 'should create a user' do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it 'should have correct success response' do
        post :create, :user => @attr
        response.should render_template(:text => 'Reistration was successful')
      end

    end
    
  end

  describe 'PUT "update"' do

    before(:each) do
      @attr = { :fio => 'Ivanov Alex',
                :email => 'ivanov@gmail.com',
                :password => '2jb23jb',
                :password_confirmation => '2jb23jb' }
      @user = User.create!(@attr)
    end

    it 'should be redirect to main' do
      put :update,  :id => @user
      response.should redirect_to root_path
    end


  end

end
