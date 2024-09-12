class AdmUserController < ApplicationController
  layout "admin"
  
  PERPAGE = 3
  
  before_action :can_access

  after_action :track_action
  
  def list
    @page = 0
    @query = {}
    @users = get_users(@page, @query)
    
    #render 'users', locals: { part:'main_lista_users', selected: 'lista' }
    
    respond_to do |format|
      format.html {render 'users', locals: { part:'main_lista_users', selected: 'lista' }}
      format.js { render 'lista_users' }
    end
  end
  
  def next_page
    @page = params[:page].to_i
    @query = eval(params[:query].to_s)
    
    @users = get_users(@page, @query)
    
    html = render_to_string(partial: 'lista_users')
    
    
    render json: { html: html, more: @more, query: @query.to_s, page: @page + 1}
  end
  
  def filter_lista
    @page = 0
    @query = {query: params[:find][:query], tipo: params[:find][:tipo] }
    
    @users = get_users(@page, @query)
    
    render 'filter_lista'
  end
  
  def new_user
    @user = User.new
    
    render 'new_user'    
  end
  
  def create_user
    @user = User.new(adm_user_params)
    @user.password = rand(36**12).to_s(36)
    @user.password_confirmation = @user.password
    @user.terms_acpetd = true
    respond_to do |format|
      if @user.save
        Signup.confirm_email(@user).deliver_later
        @profile = @user.profile
        flash[:msg] = 'Usuário criado'

        format.turbo_stream  { render turbo_stream: turbo_stream.replace('adm_user_data', partial: 'adm_user/edit_user' ) }
      else
        flash[:msg] = ''

        format.turbo_stream  { render turbo_stream: turbo_stream.replace('adm_user_data', partial: 'adm_user/new_user' ) }
      end
    end    
    
  end
  
  def show
    @user = User.find(params[:user_id])
    flash[:msg] = ''
    render 'edit_user_modal'
  end

  def modal_update_user
    @user = User.find(params[:user_id])

    if @user.update(adm_user_params)
      flash[:msg] = 'Registro gravado'
    else
      flash[:msg] = ''
    end

    respond_to do |format|
      format.turbo_stream  { render turbo_stream: turbo_stream.replace('adm_user_data', partial: 'show_user' ) }
    end

  end

  def send_confirm_mail_user
    @user = User.find(params[:user_id])
    Signup.confirm_email(@user).deliver_now

    render 'confirmation_sended'
  end

  def update_user
    @user = User.find(params[:user_id])

    if @user.update(adm_user_params)
      flash[:msg] = 'Registro gravado'
    else
      flash[:msg] = ''
    end

    respond_to do |format|
      format.turbo_stream  { render turbo_stream: turbo_stream.replace('adm_user_data', partial: 'edit_user' ) }
    end

  end
  
  private
  
  def adm_user_params
    params.require(:user).permit(:nome, :email, :nascimento, :user_level)
  end
  
  def get_users(page, filtro)
    
    if filtro.blank?
      lista = User.order(:email).offset(PERPAGE * page).limit(PERPAGE)
      @count = User.all.count
    else
      sql = []
      if filtro[:query].present?
        sql << "(nome ILIKE '%#{filtro[:query]}%' OR email ILIKE '%#{filtro[:query]}%')"
      end
      if filtro[:tipo].present?
        sql << "user_level = #{filtro[:tipo]}"
      end
      query = sql.join(' AND ')
      
      lista = User.where(query).order(:email).offset(PERPAGE * page).limit(PERPAGE)
      @count = User.where(query).count
      
    end
    
    @more = ( @count > (PERPAGE * (page + 1)) ? 1 : 0 )
    
    return lista
  end
  
  
  def can_access
    unless user_signed_in? && current_user.user_level <= 1
      redirect_to admin_path
    end
  end

  def track_action
    ahoy.track "AdmUser action", request.path_parameters
  end
  
end  
