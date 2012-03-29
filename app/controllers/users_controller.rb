class UsersController < ApplicationController

  layout 'cabinet', :only => [:show]

  before_filter :authenticate, :only => [:show, :update]
  before_filter :correct_user, :only => [:show, :update]

  # POST create new user (ajax)
  def create
    @user = User.new(params[:user])
    if @user.save
      render :text => '{"msg":"Registration was successfull"}'
    else
      errors = json_errors(@user.errors.full_messages)
      render :text => errors
    end
  end

  # GET new user for registration (ajax)
  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  # GET show user's information
  def show
    @user = User.find(params[:id])
    respond_to do |format|
        format.html
    end
  end

  # PUT update user's information
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render :text => '{"msg":Update was successful}'
    else
      errors = json_errors(@user.errors.full_messages)
      render :text => errors
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end 
end
