class SessionsController < ApplicationController

  layout 'index', :only => [:new]

  before_filter :redirection, :only => [:new]

  # GET authorization form
  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  # POST create session
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])

    if user.nil?
      render :text => 'Invalid couple e-mail/password' 
    else
      sign_in user
      render :text => user_path(user)
    end
  end

  # DELETE destroy session (logout)
  def destroy
    sign_out
    redirect_to root_path
  end

  private
    
    # redirect to private office if user was authorized
    def redirection
      redirect_to current_user unless !signed_in?
    end

end
