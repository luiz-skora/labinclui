class ApplicationController < ActionController::Base
  
  after_action :track_action
  
  delegate :current_user, :user_signed_in?, to: :user_session
  
  helper_method :current_user, :user_signed_in?
  
  def user_session
    UserSession.new(session)
  end
  
  def user_require_authentication
    unless user_signed_in?
      redirect_to admin_path
    end
  end



  protected

  def track_action
    ahoy.track "Ran action", request.path_parameters
  end
end
