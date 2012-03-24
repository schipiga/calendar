require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :fio => 'Chipiga Sergey',
      :email => 'sportsedrik@mail.ru',
      :password => 'DoberMan',
      :password_confirmation => 'DoberMan'
    }
  end

  it 'should create a new instanse given valid attributes' do
    User.create!(@attr)
  end
  
  it 'should not require a name' do
    no_name_user = User.new(@attr.merge(:fio => ''))
    no_name_user.should be_valid
  end

  it 'should require an e-mail' do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it 'should refuse a long name' do
    long = 'x' * 51
    long_name_user = User.new(@attr.merge(:fio => long))
    long_name_user.should_not be_valid
  end

  it 'should accept valid email' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should refuse duplicate emails' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should refuse emails identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe 'password validation' do
    
    it 'should require a password' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
        should_not be_valid
    end

    it 'should require a password confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).should_not
        be_valid
    end

    it 'should refuse a short password' do
      short = 'b' * 5
      attr = @attr.merge(:password => short, :password_confirmation => short)
      User.new(attr).should_not be_valid
    end

    it 'should reject a long password' do
      long = 'c' * 41
      attr = @attr.merge(:password => long, :password_confirmation => long)
      User.new(attr).should_not be_valid
    end

  end

  describe 'password encryption' do

    before(:each) do
      @user = User.create!(@attr)
    end
    
    it 'should set the encrypted password' do
      @user.encrypted_password.should_not be_blank
    end
   
    describe 'has_password? method' do
      
      it 'should be true if the passwords match' do
        @user.has_password?(@attr[:password]).should be_true
      end

      it 'should be false if the passwords dont match' do
        @user.has_password?('invalid').should be_false
      end

    end
   
    describe 'authenticate method' do
      
      it 'should return nil on e-mail/password mismatch' do
        wrong_password_user = User.authenticate(@attr[:email], 'wrongpswd')
        wrong_password_user.should be_nil
      end

      it 'should return nil for non-exist e-mail' do
        nonexistent_user = User.authenticate('bla@bla.com', @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it 'should return the user on e-mail/password match' do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end

    end
    
  end

end
