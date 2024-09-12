class AdminController < ApplicationController
  layout "admin"
  
  before_action :can_access, except: [:index]

  after_action :track_action

  def index
    if user_signed_in?
      respond_to do |format|
        format.html {render 'signed_admin'}
        format.js { render 'redicet_admin' }
      end
    else
      render 'require_login'
    end
  end
  
  def configuracoes
    @grupos = ConfGrupo.order(:nome)
    
    render 'configuracoes'
  end
  
  def conf_grupo_new
    @grupo = ConfGrupo.new
    respond_to do |format|
      format.js {render 'conf_grupo_new'}
      format.turbo_stream { render 'admin/conf_grupo_new' }
    end
  end
  
  def conf_grupo_create
    @grupo = ConfGrupo.new(conf_grupo_params)
    flash[:msg] = ''
    if @grupo.save
      @grupos = ConfGrupo.order(:nome)
      flash[:msg] = 'Grupo criado'
      respond_to do |format|
        format.turbo_stream do 
          render turbo_stream:
          [
            turbo_stream.replace('configuracoes_data', partial: 'admin/conf_grupo_edit' ) ,
            turbo_stream.replace('configuracoes_tree', partial: 'admin/conf_grupo_tree_itens', locals: { grupo_selected: @grupo.id, conf_selected: 0} )
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('configuracoes_data', partial: 'admin/conf_grupo_new' ) }
      end
    end
  end

  def conf_grupo_edit
    flash[:msg] = ''
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    render 'conf_grupo_edit'
  end
  
  def conf_grupo_update
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    
    if @grupo.update(conf_grupo_params)
      flash[:msg] = 'Registro Gravado'
    else
      flash[:msg] = ''
    end
    @grupos = ConfGrupo.order(:nome)
    respond_to do |format|
        format.turbo_stream do 
          render turbo_stream:
          [
            turbo_stream.replace('configuracoes_data', partial: 'admin/conf_grupo_edit' ) ,
            turbo_stream.replace('configuracoes_tree', partial: 'admin/conf_grupo_tree_itens', locals: { grupo_selected: @grupo.id, conf_selected: 0} )
          ]
        end
      end
  end
  
  def conf_grupo_remove
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    
    if @grupo.conf.count == 0
      ahoy.track "remoção de ConfGrupo.", { id: "#{@grupo.id}", nome: "#{@grupo.nome}", user: "#{current_user.id}" }
      @grupo.destroy
      
      @grupos = ConfGrupo.order(:nome)
      render 'conf_grupo_removido'
    else
      render 'conf_grupo_remove_fail'
    end
    
  end
  
  def conf_new
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    @conf = @grupo.conf.new
    
    render 'conf_new'
  end
  
  def conf_create
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    @conf = @grupo.conf.new(conf_params)
    
    if @conf.save
      @grupos = ConfGrupo.order(:nome)
      flash[:msg] = 'Configuração Criada'
      respond_to do |format|
        format.turbo_stream do 
          render turbo_stream:
          [
            turbo_stream.replace('configuracoes_data', partial: 'admin/conf_edit' ) ,
            turbo_stream.replace('configuracoes_tree', partial: 'admin/conf_grupo_tree_itens', locals: { grupo_selected: @grupo.id, conf_selected: @conf.id} )
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('configuracoes_data', partial: 'admin/conf_new' ) }
      end
    end
    
  end
  
  def conf_edit
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    @conf = @grupo.conf.find(params[:conf_id])
    
    render 'admin/conf_edit'
  end
  
  def conf_update
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    @conf = @grupo.conf.find(params[:conf_id])
    
    if @conf.update(conf_params)
      flash[:msg] = 'Registro Gravado'
    else
      flash[:msg] = ''
    end
    @grupos = ConfGrupo.order(:nome)
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream:
        [
          turbo_stream.replace('configuracoes_data', partial: 'admin/conf_edit' ) ,
          turbo_stream.replace('configuracoes_tree', partial: 'admin/conf_grupo_tree_itens', locals: { grupo_selected: @grupo.id, conf_selected: @conf.id} )
        ]
      end
    end
  end
  
  def conf_remove
    @grupo = ConfGrupo.find(params[:conf_grupo_id])
    @conf = @grupo.conf.find(params[:conf_id])
    
    ahoy.track "remoção de Configuração.", { id: "#{@conf.id}", nome: "#{@conf.nome}", valor: "#{@conf.valor}", user: "#{current_user.id}" }
    
    @conf.destroy
    
    @grupos = ConfGrupo.order(:nome)
    
    render 'conf_removido'
    
  end

  def backups

    render 'backups'

  end


  def stats
    get_stats_rt

    render 'stats'
  end

  def stats_refresh
    get_stats_rt

    render json: { minutes: @chart_min.to_a, seconds: @chart_sec.to_a, urls: @urls.to_json, visits: @visit_data.to_json }
  end
  
  private 
  
  def conf_grupo_params
    params.require(:conf_grupo).permit(:nome)
  end
  
  def conf_params
    params.require(:conf).permit(:nome, :valor, :as_attachment, :attachment)
  end
  
  def can_access
    unless user_signed_in? && current_user.user_level <= 1
      redirect_to admin_path
    end
  end

  def track_action
    ahoy.track "Admin action", request.path_parameters
  end

  def get_stats_rt

    t = Time.now

    @timeIni = (t - 59.minute).change(sec: 0).utc

    @chart_min = (0..59).map{|k| [@timeIni + k.minute, 0]}.to_h


    @chart_min.merge! Ahoy::Event.where('name = ?', 'Visitor action').where('time >= ?', @timeIni ).group("DATE_TRUNC('minute', time)").count

    last_min = (t - 59.second).change(usec: 0).utc

    @chart_sec = (0..59).map{|k| [last_min + k.second, 0]}.to_h

    @chart_sec.merge! Ahoy::Event.where('name = ?', 'Visitor action').where('time >= ?', last_min).group("DATE_TRUNC('second', time)").count

    @urls = Ahoy::Event.where('name = ?', 'Visitor action').where('time >= ?', t - 1.hour).group(:properties).order('COUNT(properties) DESC').count

    visit_ids = Ahoy::Event.where('name = ?', 'Visitor action').where('time >= ?', t - 1.hour).group(:visit_id).pluck(:visit_id)

    visitas = Ahoy::Visit.where(id: visit_ids)

    @visit_data = {}

    @visit_data.merge!(browser: visitas.where.not(browser: nil).group(:browser).order('COUNT(browser) DESC').count)
    @visit_data.merge!(device: visitas.group(:device_type).order('COUNT(device_type) DESC').count )
    @visit_data.merge!(os: visitas.group(:os).order('COUNT(os) DESC').count )
    @visit_data.merge!(city: visitas.group(:city).order('COUNT(city) DESC').count )
  end
 
end
