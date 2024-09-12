class PostController < ApplicationController

  layout "admin"

  PERPAGE = 20

  before_action :can_access

  after_action :track_action

  def lista
    @page = 0
    @query = ''
    @posts = get_posts(@page, @query)

    #@all_tags = Tag.order(:nome)

    respond_to do |format|
      format.html { render 'posts', locals: {part: 'main_lista_posts', selected: 'lista'}}
      format.js { render 'lista_posts'}
    end
  end

  def next_page
    @page = params[:page].to_i
    @query = params[:query]

    @posts = get_posts(@page, @query)

    html = render_to_string(partial: 'lista_posts')

    render json: { html: html, more: @more, query: @query, page: @page + 1 }

  end

  def filter_lista
    @page = 0
    @query = params[:query]


    @posts = get_posts(@page, @query)

    render 'filter_lista'
  end

  def item_actions
    @post = Post.find(params[:post_id])

    flash["msg_#{@post.id}"] = ''

    render "post_item_actions"
  end

  def short_update
    @post = Post.find(params[:post_id])

    if @post.update(short_update_params)
      flash["msg_#{@post.id}"] = 'Registro gravado'
    else
      flash["msg_#{@post.id}"] = ''
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("post-titulo-#{@post.id}", plain: @post.titulo),
          turbo_stream.update("post-status-#{@post.id}", plain: t(@post.status) ),
          turbo_stream.replace("short-edit-post-#{@post.id}", partial: 'post_short_edit')
        ]
      end
    end

  end

  def new
    @post = Post.new

    @post_atts = @post.attachment

    flash["msg_post_new"] = ''
    respond_to do |format|
      format.turbo_stream { render turbo_stream:  turbo_stream.update('adm-work-area', partial: 'post/post_new')}
      format.html { render 'post_new' }
    end

  end

  def create
    @post = Post.new(post_params)

    if @post.save
      flash["msg_#{@post.id}"] = 'Publicação Criada'
      respond_to do |format|
        @post_atts = @post.attachment.order(:created_at)
        format.turbo_stream { render turbo_stream:  turbo_stream.update('adm-work-area', partial: 'post/post_edit')}
        format.html { render 'post_edit' }
      end
    else
      flash["msg_post_new"] = ''
      respond_to do |format|
        format.turbo_stream { render turbo_stream:  turbo_stream.update('adm-work-area', partial: 'post/post_new')}
        format.html { render 'post_new' }
      end
    end
  end

  def create_tag
    @new_tag = Tag.new(nome: params[:tag_name])

    if @new_tag.save
      render json: { id: @new_tag.id, nome: @new_tag.nome, identifier: @new_tag.identifier }
    else
      render json: { error_message: @new_tag.errors.messages }
    end
  end

  def post_edit

    #https://kuy.io/blog/posts/modern-front-end-magic-with-rails-7-a-visual-editor-for-markdown-part-1#initial-project-setup
    @post = Post.find(params[:post_id])

    @post.origin = 'App'
    @post.content.body = helpers.prepare_edit(@post.content.body)

    @post_atts = @post.attachment.order(:created_at)
    #@post.content.body.to_trix_html.gsub(/\n/, '<br>')

    flash["msg_#{@post.id}"] = ''
    respond_to do |format|
      format.turbo_stream { render turbo_stream:  turbo_stream.update('adm-work-area', partial: 'post/post_edit')}
      format.html { render 'post_edit' }
    end

  end

  def post_update
    @post = Post.find(params[:post_id])
    @post.origin = 'App'
    if @post.update(post_params)
      @post.content.body = helpers.prepare_edit(@post.content.body)
      @post_atts = @post.attachment.order(:created_at)
      flash["msg_#{@post.id}"] = 'Publicação Gravada'
    else
      flash["msg_#{@post.id}"] = ''
    end

    #redirect_to adm_post_post_edit_path(@post.id)

    respond_to do |format|
      format.turbo_stream { render turbo_stream:  turbo_stream.update('adm-work-area', partial: 'post/post_edit')}
      format.html { render 'post_edit' }
      format.js { render 'post_edit' }
    end
  end

  def filter_tags
    @filter_tags = Tag.where("nome ILIKE '#{params[:find]}%'").order(:nome).limit(50)
    html = render_to_string(partial: 'filter_tags')

    render json: { html: html}
  end

  def post_view
    head :ok
  end



  private

  def short_update_params
    params.require(:post).permit(:titulo, :resumo, :status, category_ids: [], tag_ids: [])
  end

  def post_params
    params.require(:post).permit(:titulo, :resumo, :content, :status, :published_in, :changed_in, :autor, category_ids: [], tag_ids: [])
  end

  def filter_post_params
    params.require(:find).permit(:query)
  end

  def get_posts(page, filtro)

    p '***** FILTRO ****'
    p filtro

    if filtro.blank?
      lista = Post.order(published_in: :desc).offset(PERPAGE * page).limit(PERPAGE)
      @count = Post.all.count
    else
      str = []
      str << "titulo ILIKE '%#{filtro}%'"

      query = str.join(' OR ')

      lista = Post.where(query).order(published_in: :desc).offset(PERPAGE * page).limit(PERPAGE)
      @count = Post.where(query).count
    end

    @more = ( @count > (PERPAGE * (page + 1)) ? 1 : 0 )

    return lista
  end

  def can_access
    unless user_signed_in? && current_user.user_level <= 3
      redirect_to admin_path
    end
  end

  def track_action
    ahoy.track "Post action", request.path_parameters
  end
end
