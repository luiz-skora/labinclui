class Signup < ActionMailer::Base
  
  default from: "#{ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'app_mail').valor}"
  
  def confirm_email(user)
    @user = user
    
    @confirm_link = url_for(controller: :users, action: :confirmation, host: "#{ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'site_url').valor}", params: { email: @user.email, token: @user.token} )
    
    mail({
      to: @user.email,
      bcc: ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'app_mail').valor,
      subject: "#{ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'app_title').valor} - Confirmação de Cadastro"
    })
  end
  
  def recovery_password(user)
    @user = user
    @recovery_link = url_for(controller: :users, action: :resset_password, host: "#{ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'site_url').valor}", params: { email: @user.email, token: @user.recovery_token})
    mail({
      to: @user.email,
      bcc: ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'app_mail').valor,
      subject: "#{ConfGrupo.find_by(nome: 'Aplicação').conf.find_by(nome: 'app_title').valor} - Recuperação de Senha"
    })
  end
end
