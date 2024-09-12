class VisitorController < ApplicationController

  layout "visitor"

  before_action :get_device

  after_action :track_action, only: [:visitor_navigation, :form_find_posts]

  PERPAGE = 10

  def visitor_navigation

      @device = current_visit.device_type || 'Mobile'

      #@device = 'Mobile'

      page = App.first.page.find_by(identifier: get_page_data )

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


      render '/home/home'



  end

  def by_identifier

  end


  def show_component
    @component = ActionText::Attachable.from_attachable_sgid(params[:sgid])

    if @component.present?
      pm = Pagemaker.find_by(identifier: @component.pagemaker_identifier )
      html = ApplicationController.render(partial: "#{pm.html_base}", locals: { fields: @component.fields.symbolize_keys})

      respond_to do |format|
        format.turbo_stream {render turbo_stream: turbo_stream.update("#{params[:element]}", partial: "#{pm.html_base}", locals: { fields: @component.fields.symbolize_keys}) }
        format.json { render json: {html: html} }
      end
    else
      render json: { html: '<div class="msg">Não foi possivel carregar o elemento.</div>'}
    end
  end

  def featured_image_post
    post = Post.find(params[:post_id])
    if post.featured_image.present?
      blob = post.featured_image
    elsif post.attachment.present?
      blob = post.attachment.first
    else
      blob = nil
    end
    #h = (params[:h].to_i > 32 ? params[:h].to_i : 32)
    #w = (params[:w].to_i > 32 ? params[:w].to_i : 32)

    respond_to do |format|
      format.turbo_stream { render turbo_stream:  turbo_stream.update("slide-#{params[:element]}", render_to_string(partial: 'active_storage/image', locals: { blob: blob, w: params[:w].to_f, h: params[:h].to_f}))}

      format.json  { render json: {blob: helpers.load_blob(blob, params[:w].to_f, params[:h].to_f, true) } }
    end

  end

  def load_image_post
    post = Post.find(params[:post_id])
    if post.featured_image.present?
      blob = post.featured_image
    elsif post.attachment.present?
      blob = post.attachment.first
    else
      blob = nil
    end
    h = (params[:h].to_i > 32 ? params[:h].to_i : 32)
    w = (params[:w].to_i > 32 ? params[:w].to_i : 32)

    respond_to do |format|
      format.turbo_stream {render turbo_stream:  turbo_stream.update("#{params[:element]}", render_to_string(partial: 'active_storage/image', locals: { blob: blob, w: w, h: h}))}

      format.json { render json: {blob: helpers.load_blob(blob, w, h, true) } }
    end
  end

  def load_image_blob
    blob = ActiveStorage::Blob.find(params[:blob_id])

    h = (params[:h].to_i > 32 ? params[:h].to_i : 32)
    w = (params[:w].to_i > 32 ? params[:w].to_i : 32)

    respond_to do |format|
      format.turbo_stream {render turbo_stream:  turbo_stream.update("#{params[:element]}", render_to_string(partial: 'active_storage/image', locals: { blob: blob, w: w, h: h}))}

      format.json { render json: {blob: helpers.load_blob(blob, w, h, true) }}
    end
  end

  def load_att_src
    blob = ActiveStorage::Blob.find_signed(params[:att])
    w = (params[:w].to_i > 32 ? params[:w].to_i : 32)
    if blob.image? && blob.variable?
      render json: {src: url_for(blob.variant(resize_to_limit: [w, nil])), alt: blob.filename.to_s}
    else
      head :ok
    end
  end



  def form_find_posts

    conf_home_page = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(nome: 'Página Inicial').valor rescue 'home'

    #@device = current_visit.device_type || 'Mobile'

    @meta = helpers.home_meta_tags

    page = App.first.page.find_by(identifier: conf_home_page)

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

    render 'form_find_posts'
  end

  def lgpd_message_accept
    cookies[:lgpd] = {value: 'true', expires: 3.hours.from_now }
    head :ok
  end

  private

  def get_device
    @device = current_visit.device_type || 'Mobile'
    #@device = 'Mobile'
  end

  def get_page_data
    conf = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(valor: params[:base]).nome rescue 'home'

    case conf
    when 'Base de Publicação'
      @post = Post.find_by(identifier: params[:identifier])
      @meta = helpers.post_meta_tags(@post) rescue helpers.home_meta_tags

      p @meta
      return ConfGrupo.find_by(nome: 'Navegação').conf.find_by('Página de Publicação').valor rescue 'publicacao'
    when 'Base de páginas'

      #tem erro aqui. CORRIJA

      @meta = helpers.page_meta_tags(params[:identifier])  rescue helpers.home_meta_tags

      #@meta = helpers.home_meta_tags


      return params[:identifier] rescue 'home'
    when 'Base de Categorias'
      @categoria = Category.find_by(identifier: params[:identifier])
      @meta = helpers.category_meta_tags(@category)  rescue helpers.home_meta_tags
      return ConfGrupo.find_by(nome: 'Navegação').conf.find_by('Página de Categorias').valor rescue 'categoria'
    when 'Base de Tags'
      @tag = Tag.find_by(identifier: params[:identifier])
      @meta = helpers.tag_meta_tas(@tag)  rescue helpers.home_meta_tags
      return ConfGrupo.find_by(nome: 'Navegação').conf.find_by('Página de Tags').valor rescue 'tag'
    else
      @meta =  helpers.home_meta_tags
      return 'home'
    end



  end

  def track_action
    ahoy.track "Visitor action", request.path
  end

end
