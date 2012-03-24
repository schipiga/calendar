class EventsController < ApplicationController
  
  include EventsHelper

  before_filter :authenticate

  def new
    @event = current_user.events.new
    respond_to do |format|
      format.js
    end
  end  
    
  def share_events
    @events = Event.where('is_share = ?', true)
    respond_to do |format|
      format.js
    end
  end

  def user_events
    @events = current_user.events
    respond_to do |format|
      format.js
    end
  end

  def day_events
    @events = events_in_day(params[:date])
    respond_to do |format|
      format.js
    end
  end

  def month_events
    @events = events_in_month(params[:month], params[:year])
    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def show_share
    @event = Event.where('id = ? AND is_share = ?', params[:id], true)[0]
    respond_to do |format|
      format.js { render 'show' }
    end
  end

  def show_my
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.js { render 'show' }
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @event = current_user.events.new(params[:event])
    if @event.save
      render :text => '' 
    else
      render :text => "Can't create!"
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    if @event.update_attributes(params[:event])
      render :text => ''
    else
      render :text => "Can't update!"
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    if @event.destroy
      render :nothing => true
    end
  end
end
