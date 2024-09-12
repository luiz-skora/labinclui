class UserSessionsController < ApplicationController
  
  ### Atenção!
  ### user_session ainda não está completo. é preciso inserir os campos e valores para localização, device, user agent, etc, na tabela login. 
  ### Impedir login no caso de informação diferente do já registrado na tabela, enviar token para validação de login com dados diferentes, bloquear login depois de algumas tentativas inválidas dependendo da senha ou email ou ainda, token de current_visit
  
  invisible_captcha only: [:create, :update], honeypot: :subtitle, on_timestamp_spam: :spam_message, timestamp_threshold: 3

  after_action :track_action
  
  def new
    @user_session = UserSession.new(session)
  end
  
  def create


    if params[:detect].nil? || params[:is_human].to_i.to_s(32) == params[:detect] 

      @user_session = UserSession.new(session, params[:user_session])
    
      if @user_session.authenticate!(current_visit)
        #format.js { render 'success_login' }
        ahoy.authenticate(current_user)
        flash[:tentativa] = nil
        flash[:user] = @user_session.identifier
        
        redirect_to admin_path, format: "html" 
        
      else
        flash[:user] = @user_session.identifier
        if User.find_by(email:  @user_session.email).present?
          flash[:user_id] = User.find_by(email: @user_session.email).id
        else 
          flash[:user_id] = nil
        end
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.update('login-box', partial: "user_sessions/login")}
        end
      end
    else
      spam_message
    end
  end
  
  def destroy
    user_session.destroy;
    redirect_to root_path, notice: 'logout'    
  end
  
  
  def spam_message
    flash[:span] = 'likely'
    op = rand(3)
    if op == 0
      symbol = '+'
      num_1 = rand(9) + 1
      num_2 = rand(5) + 1
      res = num_1 + num_2
    elsif op == 1
      symbol = '-'
      num_1 = rand(6) + 5
      num_2 = rand(5) + 1
      res = num_1 - num_2
    else
      symbol = ' x'
      num_1 = rand(9) + 1
      num_2 = rand(5) + 1
      res = num_1 * num_2
    end
    
    flash[:question] = "#{num_1.humanize(locale: 'pt')} #{symbol} #{num_2}"
    flash[:response] = "#{res.to_s(32)}" #"#{(res * 64).to_s(32)}"
    flash[:span_message] = 'Você foi muito rápido!<br>Preencha novamente o formulário de login e aguarde alguns instantes antes de enviar. '

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('login-box', partial: "user_sessions/login", locals: { potential_span: true})}
    end

    #render 'potential_span'
  end

  private

  def track_action
    ahoy.track "UserSession action", request.path_parameters
  end
end


