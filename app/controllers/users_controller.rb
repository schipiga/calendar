class UsersController < ApplicationController

  layout 'cabinet', :only => [:show]

  before_filter :authenticate, :only => [:show, :update]
  before_filter :correct_user, :only => [:show, :update]


  def create
    @user = User.new(params[:user])
    if @user.save
      render :text => 'Registration was successfull'
    else
      render :text => 'Sorry, something is wrong'
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.nil?
        render :text => 'Sorry, its absent'
      else
        format.html
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render :text => 'Update was successfull'
    else
      render :text => 'Sorry, something is wrong'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end 
end
