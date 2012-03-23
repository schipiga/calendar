class SessionsController < ApplicationController

  layout 'index', :only => [:new]

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end


  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])

    if user.nil?
      redirect_to root_path
    else
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
