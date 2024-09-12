require 'ahoy'

class UserSession
  include ActiveModel::Model
  
  #parametros da função chk_logs devem ser definidos no app de administração e configurados conforme o uso em produção
  
  attr_accessor :email, :password, :identifier
  validates_presence_of :email, :password
  
  def initialize(session, attributes={})
    @session = session
    @email = attributes[:email]
    @password = attributes[:password]
  end
  
  def authenticate!(visit)
    u = chk_login(@email)
    
    ##c = chk_logs(u) ## habilitar quando da proteção
    
    if u.present?
      if !u.confirmed?
        errors.add(:base, :unconfirmed_user)
        errors.add(:unconfirmed_user , 1)
        self.identifier = u.login
        l = LoginLog.register_login(visit, u.login, 'unconfirmed user -' + @email)
        return false
      else
        user = User.authenticate(u.email, @password)
        if user.present?
          l = LoginLog.register_login(visit, u.id, 'OK')
          
          store(user)
          
          
        else 
          errors.add(:base, :invalid_login)
          l = LoginLog.register_login(visit, u.id, 'invalid password ' + @email)
          false
        end    
      end
    else
     errors.add(:base, :invalid_login)
     l = LoginLog.register_login(visit, nil, 'invalid login -' + @email)
     false
    end
  end
  
  def store(user)
    @session[:user_id] = user.id
  end
  
  def current_user
    if user_signed_in?
      User.find(@session[:user_id])
    else
      nil
    end
  end
  
  def user_profile
    if user_signed_in?
      User.find(@session[:user_id]).profile_person
    else
      nil
    end
  end
  
  
  def user_signed_in?
    @session[:user_id].present?
  end
  
  def destroy
    @session[:user_id] = nil
  end
  
  def is_confirmation?
    u = User.find_by(login: params[:identifier])
    u.token.present? && u.token == params[:token]
  end
  
  def current_profile
    if user_signed_in? || is_confirmation?
      Profile.find_by(identifier: params[:identifier])
    else
      nil
    end
  end  
              
  
  private
  
  def chk_login(user_login)
    if user_login.count('@') == 1
      u = User.find_by(email: user_login)
    else
      u = User.find_by(login: user_login)
    end 
    return u 
  end
  
  def chk_logs(user)
#     bf_minutes = 10 #definir este valor no app de adminstração
#     is_bf = 10 # tentativas de login - definir este valor no app de administração
#     #varre a tabela login_logs para verificar tentativas de login 
#     if !user.present?
#       #bloqueia brute force e redireciona login para página com captcha
#       bf = LoginLog.where('status LIKE ? ', 'invalid login%').where(created_at: bf_minutes.minutes.ago..DateTime.now).count
#       if bf >= is_bf
#         return 'brute_force'
#       else
#         #verifica se o usuário esqueceu a senha ou se é uma tentativa de invasão à conta deste usuário
#         #logs_ok = Lo...
#         
      
    
  end
  


end

