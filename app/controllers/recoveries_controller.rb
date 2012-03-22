class RecoveriesController < ApplicationController

  include RecoveriesHelper

  def index 
    if rec = Recovery.find_by_key(params[:key])
      @user = rec.user
      render 'users/_form_user'
    end
  end

  def new
    $rec = Recovery.new
    respond_to do |format|
      format.js
    end
  end

  def create
    if user = User.find_by_email(params[:recovery][:email])
      Recovery.deleteall(['user_id = ?', user[:id]])
      @rec = Recovery.new(rec_key(user[:email]), user[:id])
      @res.save
      UserMailer.recovery_pswd(user).deliver
    end
  end

  def destroy

  end

end
