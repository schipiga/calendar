class RecoveriesController < ApplicationController

  layout 'index', :only => [:show] 
  
  include RecoveriesHelper

  def show 
    if rec = Recovery.find_by_key(params[:key])
      @user = rec.user
      @key = params[:key]
      respond_to do |format|
        format.html
      end
    end
  end

  def new
    $rec = Recovery.new
    respond_to do |format|
      format.js
    end
  end

  def create
    user = User.find_by_email(params[:recovery][:email])
    render :text => 'stub'
=begin
    if user.nil?
      render :text => 'User not found' 
    else
      # Recovery.delete_all(['user_id = ?', user[:id]])
      render :text => 'User found'
=begin
      key = rec_key(user[:email])
      rec = Recovery.new(:key => key, :user_id => user[:id])
      if rec.save
        email = UserMailer.recovery_pswd(user[:email], root_url + 'recovery?key=' + key).deliver
        # render :text => root_url + 'recovery?key=' + key
        render :text => 'sended'
      else
        render :text => "can't send"
      end
=end
    end
  end

  def update
    if Recovery.find_by_key(params[:key])   
      @user = User.find_by_email(params[:user][:email])
      if @user.update_attributes(params[:user])
        render :text => 'Update was successfull'
      else
        render :text => 'Sorry, something is wrong'
      end
    else
      render :text => 'Access denied!'
    end
  end
end
