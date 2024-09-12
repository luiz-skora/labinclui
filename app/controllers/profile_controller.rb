class ProfileController < ApplicationController 
  
  before_action :can_access
  before_action :can_change, only: [:edit, :update, :change]

  after_action :track_action

  def show
    
  end
  
  def show_modal
    @current_profile = Profile.find(params[:profile_id].to_i(32))
    @profile = Profile.find_by(identifier: params[:profile_identifier])
    render 'show_modal'
  end
  
  private
  
  def can_access
    unless user_signed_in?
      redirect_to root_path
    end
  end
  
  def can_change
    unless user_signed_in? && current_user.person.identifier == params[:profile_identifier]
      redirect_to root_path
    end
  end 

  def track_action
    ahoy.track "profile action", request.path_parameters
  end
end
