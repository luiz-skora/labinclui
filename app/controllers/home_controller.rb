class HomeController < ApplicationController
  layout "visitor"

  after_action :track_action


  caches_page :index


  def index
    conf_home_page = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(nome: 'Página Inicial').valor rescue 'home'

    @device = current_visit.device_type || 'Mobile'
    #@device = 'Mobile'

    page = App.first.page.find_by(identifier: conf_home_page)

    @meta = helpers.home_meta_tags
    case @device
    when 'Mobile'
      @page = (page.children.find_by(device: 'Mobile'))
      @page = (@page.nil? ? page : @page)

    when 'Tablet'
      @page = (page.children.find_by(device: 'Talet'))
      @page = (@page.nil? ? page : @page)

    else
      @page = page

    end

    render 'home'
  end


  
  def adm_require_login
    flash[:span_message] = nil
    flash[:span] = nil
    @user_session = UserSession.new(session)
    @lauout = 'admin'
    render 'admin/form_login'
    
  end

  def clear_cache
    expire_page controller: :home, action: :index

    redirect_to root_path
  end

  private

  def track_action

    ahoy.track "Visitor action", request.path
  end



end
