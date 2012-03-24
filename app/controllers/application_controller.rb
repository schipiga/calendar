class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def record_not_found
    render :text => "Sorry boy :( You're out of luck"
  end

end
