class UsersController < ApplicationController
  
  before_action :can_change, only: [:edit, :update]
  before_action :require_recovery_token, only: [:resset_password, :resset_password_update]

  invisible_captcha only: [:create, :update, :send_mail_password_recovery], honeypot: :subtitle  
  
  after_action :track_action
  
  def new
    conf  = Conf.find_or_create_by(grupo: 'new_users', nome: 'user_level')
    default_level = ( conf.value.present? ? conf.value.to_i : 4 )
    @user = User.new
    respond_to do |format|
      format.js { render 'modal_new_user' }
    end    
  end
  
  def create
    @user = User.new(user_create_params)
    @user.password = rand(36**12).to_s(36)
    @user.password_confirmation = @user.password
    respond_to do |format|
      if @user.save
        Signup.confirm_email(@user).deliver_later
        #format.html { render :new }
        format.js { render 'createok' }
      else
        #f.html { redirect_to root_path }
        format.js { render 'createfail' }
      end
    end    
  end
  
  def confirmation
    @user = User.find_by(token: params[:token], email: params[:email])
    if @user.present? && @user.token.present? && @user.email == params[:email]
      @profile = @user.profile
      @user.password_digest = nil      
      render 'confirmation'
    else
      if User.find_by(email: params[:email])
        redirect_to root_path
      else
        render 'invalid_token'
      end
    end
  end
  
  def resset_password
    
  end
  
  def user_confirmation
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.update(confirmation_params)
        @user.confirmation_at = DateTime.now
        @user.token = nil
        @user.save
        @user_session = UserSession.new(session)
        @user_session.email = @user.email
        format.js { render 'user_confirmated' }
        format.html { render 'user_confirmated' }
      else     
        format.js { render 'confirmation' }
        format.html { render 'confirmation' }
      end
    end    
  end
  
  def send_confirm_mail
    @user = User.find(params[:user_id])
    if @user.present?
      Signup.confirm_email(@user).deliver_later
      flash[:send_mail] = "email enviado para, #{@user.email}"
    else
      flash[:send_mail] = "Não foi possivel enviar o email de confirmação"
    end
    respond_to do |format|
      format.js { render 'ressend_confirmation_mail' }
      format.html { render 'ressend_confirmation_mail'}
    end
  end
  
  def request_password_recovery
    respond_to do |format|
      format.js { render 'request_password_recovery' }
      format.html { render 'request_password_recovery' }
    end                
  end
  
  def send_mail_password_recovery
    @user = User.find_by(email: params[:recovery_email])
    if @user.present? 
      if @user.confirmation_at.present?
        @user.generate_recovery_token
        
        Signup.recovery_password(@user).deliver_later
        
        render 'send_mail_password_recovery'
        
      else
        render 'recovery_unconfirmed_user'
      end
    else
      render 'recovery_invalid_email'       
    end
  end
  
  def resset_password
    @user = User.find_by(email: params[:email], recovery_token: params[:token])
    if @user.present? && @user.email == params[:email] && @user.recovery_token.present? && @user.recovery_token == params[:token]
      render 'resset_password'
    end    
  end
  
  def resset_password_update
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.recovery_token.present? && params[:token] == @user.recovery_token && @user.email == params[:email]
        if @user.update(resset_password_params)
          @user.recovery_token.clear
          @user.save
          flash[:message] = 'Sua senha foi alterada'
          format.js { render 'password_updated' }
          format.html { render 'user_sessions/login' }
        else
          format.js { render 'form_resset_password' }
          format.js { render 'form_resset_password' }
        end
      else
        flash[:message_title] = 'Senha inalterada'
        flash[:message] = 'Não foi possivel alterar a senha.'
        redirect_to message_path
      end  
    end
  end
  
  
  private 
  
  def user_create_params
    params.require(:user).permit(:nome, :email, :nascimento, :terms_acpetd)
  end
  
  def confirmation_params
    params.require(:user).permit(:password, :password_confirmation, profile_attributes: [:id, :nickname, :bio])
  end

  def resset_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def can_change
    unless user_signed_in?
      redirect_to user_path(params[:id])
    end
  end
  
  def require_recovery_token
    unless params[:token].present?
      flash[:message_title] = 'Endereço inválido'
      flash[:message] = 'O endereço informado não existe.'
      redirect_to message_path
    else
      t = User.find_by(recovery_token: params[:token])
      unless t.present? && t.email == params[:email]
        flash[:message_title] = 'Token inválido'
        flash[:message] = 'O token informado não é válido'
        redirect_to message_path
      end                       
    end
  end

  def track_action
    ahoy.track "Users action", request.path_parameters
  end
end
