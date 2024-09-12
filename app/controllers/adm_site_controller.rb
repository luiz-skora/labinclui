class AdmSiteController < ApplicationController

  layout "admin"

  PERPAGE = 20

  before_action :can_access
  before_action :clear_msg

  after_action :track_action

  def main

    home = App.first.page.find_or_create_by(nome: 'Home')
    single_post = App.first.page.find_or_create_by(nome: 'Publicação')
    @pages = App.first.page.where(device: 'Desktop').order(:nome)

    respond_to do |format|
      format.html { render 'adm_site', locals: { part: 'paginas'} }
      format.js { render 'adm_site' }
    end
  end

  def paginas
    @pages = App.first.page.where(device: 'Desktop').order(:nome)
    render 'paginas'
  end

  def areas
    header = App.first.area.find_or_create_by(nome: 'Cabeçalho')
    footer = App.first.area.find_or_create_by(nome: 'Rodapé')

    @areas = App.first.area.order(:nome)

    render 'areas'
  end

  def menus
    main = App.first.menu.find_or_create_by(nome: 'Principal')
    @menus = App.first.menu.order(:nome)
    render 'menus'
  end

  def midias

  end

  def anuncios
    @ads = App.first.ad.order(:nome)

    render 'ads'
  end

  def styles
    @app = App.first
    @style = FrontStyle.find_or_create_by(app_id: @app.id)
    flash[:msg] = ''
    render 'styles'
  end

  def scripts
    @app = App.first
    @script = FrontScript.find_or_create_by(app_id: @app.id)
    flash[:msg] = ''
    render 'scripts'
  end

  #paginas
  def pages_tree_filter
    if params[:query].blank?
      @pages = App.first.page.where(device: 'Desktop').order(:nome)
    else
      @pages = App.first.page.where(device: 'Desktop').where("nome ILIKE '%#{params[:query]}%'").order(:nome)
    end

    render 'pages_tree_filter'

  end

  def page_new
    @page = App.first.page.new

    render 'page_new'
  end

  def page_create
    @page = App.first.page.new(page_params)

    if @page.save
      flash[:msg] = 'Página Criada'
      partial = 'page_edit'
    else
      flash[:msg] = ''
      partial = 'page_new'
    end
    if @page.parent_id == nil
      @page_parent = @page
    else
      @page_parent = Page.find(@page.parent_id)
    end
    @pages = App.first.page.where(device: 'Desktop').order(:nome)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_page', partial: partial),
          turbo_stream.update('paginas_tree', partial: 'paginas_tree')
        ]
      end
    end

  end

  def page_edit
    @page = Page.find(params[:page_id])
    @page_parent = @page
    render 'page_edit'
  end

  def page_desktop
    @page_parent = Page.find(params[:page_id])
    @page = @page_parent
    render 'page_edit'
  end

  def page_tablet
    @page_parent = Page.find(params[:page_id])
    @page = @page_parent.children.find_or_create_by(device: 'Tablet', app_id: @page_parent.app_id)
    @page.nome = @page.nome.blank? ? "#{@page_parent.nome} Tablet" : @page.nome
    @page.save

    render 'page_tablet_edit'
  end

  def page_mobile
    @page_parent = Page.find(params[:page_id])
    @page = @page_parent.children.find_or_create_by(device: 'Mobile', app_id: @page_parent.app_id)
    @page.nome = @page.nome.blank? ? "#{@page_parent.nome} Mobile" : @page.nome
    @page.save

    render 'page_mobile_edit'
  end

  def page_update
    @page = Page.find(params[:page_id])
    @page_parent = @page.parent_id.present? ? @page.parent : @page
    if @page.update(page_params)
      flash[:msg] = 'Página gravada'
    else
      flash[:msg] = ''
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('form_page', partial: 'form_page')}
    end

  end



  #Áreas
  def areas_tree_filter
    if params[:query].blank?
      @areas = App.first.area.order(:nome)
    else
      @areas = App.first.area.where("nome ILIKE '%#{params[:query]}%'").order(:nome)
    end

    render 'areas_tree_filter'
  end

  def area_new
    @area = App.first.area.new

    render 'area_new'
  end

  def area_create
    @area = App.first.area.new(area_params)

    if @area.save
      flash[:msg] = 'Área criada'
      partial = 'area_edit'
    else
      flas[:msg] = ''
      partial = 'area_new'
    end

    @pages = App.first.area.order(:nome)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream [
          turbo_stream.replace('form_area', partial: partial),
          turbo_stream.update('areas_tree', partial: 'areas_tree')
          ]
      end
    end

  end

  def area_edit
    @area = Area.find(params[:area_id])

    flash[:msg] = ''

    render 'area_edit'
  end

  def area_update
    @area = Area.find(params[:area_id])

    if @area.update(area_params)
      flash[:msg] = 'Área gravada'
    else
      flash[:msg] = ''
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream:  turbo_stream.replace('form_area', partial: 'area_edit')}
    end
  end

  #Menus
  def menus_tree_filter
    if params[:query].blank?
      @menus = App.first.menu.order(:nome)
    else
      @menus = App.first.menu.where("nome ILIKE '%#{params[:query]}%'").order(:nome)
    end

    render 'menu_tree_filter'
  end

  def menu_new
    flash[:msg] = ''
    @menu = App.first.menu.new
    render 'menu_new'
  end

  def menu_create
    @menu = App.first.menu.new(menu_params)

    if @menu.save
      @menu_itens = @menu.menu_item.where(parent_id: nil).order(:indice, :nome, :id)
      flash[:msg] = 'Menu criado'
      partial = 'menu_itens'
    else
      flash[:msg] = ''
      partial = 'menu_new'
    end

    @menus = App.first.menu.order(:nome)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_menu', partial: partial),
          turbo_stream.update('menus_tree', partial: 'menus_tree')
        ]
      end
    end
  end

  def menu_edit
    flash[:msg] = ''
    @menu = Menu.find(params[:menu_id])

    @menu_itens = @menu.menu_item.where(parent_id: nil).order(:indice, :nome, :id)
    render 'menu_itens'
  end

  def menu_change
    flash[:msg] = ''
    @menu = Menu.find(params[:menu_id])

    render 'menu_change'
  end

  def menu_update
    @menu = Menu.find(params[:menu_id])
    flash[:msg] = ''
    if @menu.update(menu_params)
      @menu_itens = @menu.menu_item.where(parent_id: nil).order(:indice, :nome, :id)
      partial = 'menu_itens'
    else
      partial = 'menu_change'
    end
    @menus = App.first.menu.order(:nome)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_menu', partial: partial),
          turbo_stream.update('menus_tree', partial: 'menus_tree')
        ]
      end
    end
  end

  #Menu Itens
  def menu_itens_tree_filter

  end

  def menu_item_new
    @app = App.first
    @menu = Menu.find(params[:menu_id])
    @menu_itens = @menu.menu_item.where(parent_id: nil)
    @indice = @menu.menu_item.where(parent_id: nil).count + 1
    @menu_item = @menu.menu_item.build(tipo: 'pagina', indice: @indice)
    flash[:msg] = ''
    render 'menu_item_new'
  end

  def menu_item_create
    @app = App.first
    @menu = Menu.find(params[:menu_id])

    @menu_item = @menu.menu_item.new(menu_item_params)

    if @menu_item.save
      flash[:msg] = 'Item de menu criado'
      partial = 'menu_item_edit'
    else
      flash[:msg] = ''
      partial = 'menu_item_new'
    end

    @menu_itens = @menu.menu_item.where(parent_id: nil)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_menu_item', partial: partial),
          turbo_stream.update('adm_menu_itens_tree_itens', partial: 'menu_itens_tree_items')
        ]
      end
    end
  end

  def menu_item_edit
    flash[:msg] = ''
    @app = App.first
    @menu = Menu.find(params[:menu_id])
    @menu_itens = @menu.menu_item.where(parent_id: nil)
    @menu_item = @menu.menu_item.find(params[:menu_item_id])

    render 'menu_item_edit'
  end

  def menu_item_update
    @app = App.first
    @menu = Menu.find(params[:menu_id])
    @menu_item = @menu.menu_item.find(params[:menu_item_id])

    if @menu_item.update(menu_item_params)
      flash[:msg] = 'Item gravado'
    else
      flash[:msg] = ''
    end
    @menu_itens = @menu.menu_item.where(parent_id: nil)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_menu_item', partial: 'menu_item_edit'),
          turbo_stream.update('adm_menu_itens_tree_itens', partial: 'menu_itens_tree_items')
        ]
      end
    end

  end

  def menu_item_remove
    @app = App.first
    @menu_item = MenuItem.find(params[:menu_item_id])
    @menu = @menu_item.menu

    if !@menu_item.has_childrens?
      @menu_item.delete
      @menu_item = @menu.menu_item.first
      @msg = ''
    else
      @msg = 'Não é possivel excluir item de menu com subitens associados.'
    end
    @menu_itens = @menu.menu_item.where(parent_id: nil)
    render 'menu_item_removed'
  end

  #Anúncios
  def ads_tree_filter
    if params[:query].blank?
      @ads = App.first.ad.order(:nome)
    else
      @ads = App.first.ad.where("nome ILIKE '%#{params[:query]}%'").order(:nome)
    end

    render 'ads_tree_filter'
  end

  def ads_new
    @ad = App.first.ad.new

    render 'ads_new'
  end

  def ads_create
    @ad = App.first.ad.new(ad_params)

    if @ad.save
      flash[:msg] = 'Anúncio criado'
      partial = 'ads_edit'
    else
      flash[:msg] = ''
      partial 'ads_new'
    end
    @ads = App.first.ad.order(:nome)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_ad', partial: partial),
          turbo_stream.update('ads_tree', partial: 'ads_tree')
        ]
      end
    end
  end

  def ads_edit
    @ad = Ad.find(params[:ads_id])
    render 'ads_edit'
  end

  def ads_update
    @ad = Ad.find(params[:ads_id])

    if @ad.update(ad_params)
      flash[:msg] = 'Anúncio Gravado'
    else
      flash[:msg] = ''
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('form_ad', partial: 'ads_edit')}
    end
  end

  #styles
  def styles_update
    @app = App.find(params[:app_id])
    @style = @app.front_style

    if @style.update(styles_params)
      flash[:msg] = 'Folha de estilos gravada'
    else
      flash[:msg] = ''
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('form_styles', partial: 'styles_edit')}
    end
  end

  #scripts
  def scripts_update
    @app = App.find(params[:app_id])
    @script = @app.front_script

    if @script.update(script_params)
      flash[:msg] = 'Script gravado'
    else
      flash[:msg] = ''
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('form_scripts', partial: 'scripts_edit')}
    end
  end


  private

  def page_params
    params.require(:page).permit(:nome, :header_area_id, :footer_area_id, :content)
  end

  def area_params
    params.require(:area).permit(:nome, :content)
  end

  def ad_params
    params.require(:ad).permit(:nome, :tipo, :code, :content)
  end

  def menu_params
    params.require(:menu).permit(:nome)
  end

  def menu_item_params
    params.require(:menu_item).permit(:nome, :parent_id, :indice, :tipo, :link, :rota)
  end

  def styles_params
    params.require(:front_style).permit(:styles)
  end

  def script_params
    params.require(:front_script).permit(:header_scripts, :footer_scripts)
  end

  def can_access
    unless user_signed_in? && current_user.user_level <= 2
      redirect_to admin_path
    end
  end

  def clear_msg
    flash[:msg] = ''
  end

  def track_action
    ahoy.track "AdmSite action", request.path_parameters
  end
end
