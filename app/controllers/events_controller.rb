class EventsController < ApplicationController
  
  before_filter :authenticate
  
  # GET new event (ajax)
  def new
    @event = current_user.events.new
    respond_to do |format|
      format.js
    end
  end  
  
  # GET show shared events (ajax)
  def share_events
    @events = Event.where('is_share = ?', true)
    respond_to do |format|
      format.js
    end
  end

  # GET user_events (ajax)
  def user_events
    @events = current_user.events
    respond_to do |format|
      format.js
    end
  end

  # GET day events (ajax)
  def day_events
    @events = current_user.events.events_in_day(params[:date])
    respond_to do |format|
      format.js
    end
  end

  # GET events for days of current month (ajax)
  def month_events
    @events = current_user.events.events_in_month(params[:month], params[:year])
    respond_to do |format|
      format.json { render json: @events }
    end
  end

  # GET show detail of shared event (ajax)
  def show_share
    @event = Event.where('id = ? AND is_share = ?', params[:id], true)[0]
    respond_to do |format|
      format.js { render 'show' }
    end
  end

  # GET show detail of user event (ajax)
  def show_my
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.js { render 'show' }
    end
  end

  # GET edit event (ajax)
  def edit
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST create event (ajax)
  def create
    @event = current_user.events.new(params[:event])
    if @event.save
      render :text => '' 
    else
      render :text => "Can't create!"
    end
  end

  # PUT update event (ajax)
  def update
    @event = current_user.events.find(params[:id])
    if @event.update_attributes(params[:event])
      render :text => ''
    else
      render :text => "Can't update!"
    end
  end

  # DELETE destroy event (ajax)
  def destroy
    @event = current_user.events.find(params[:id])
    if @event.destroy
      render :nothing => true
    end
  end
end
