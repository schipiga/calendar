class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

    def record_not_found
      redirect_to current_user
    end

end
