class EventsController < ApplicationController
  
  include EventsHelper

  before_filter :authenticate

  def new
    @event = current_user.events.build
    respond_to do |format|
      format.js
    end
  end  
    
  def share
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

  def show
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @event = current_user.events.new(params[:event])
    res = {'ok' => ':)'}
    respond_to do |format|
      if @event.save
        format.json { render json: res }
      end
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    @event.update_attributes(params[:event])
  end

  def destroy
    @event = current_user.events.find(params[:id])
    res = {'ok' => ';)'}
    respond_to do |format|
      if @event.destroy
        format.json { render json: res }
      end
    end
  end
end
