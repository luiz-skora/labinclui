class CategoryController < ApplicationController

  layout "admin"

  PERPAGE = 20

  before_action :can_access

  after_action :track_action

  def lista

    @cats = Category.where(parent_id: nil).order(:identifier)

    respond_to do |format|
      format.html { render 'categories_tree' }
      format.js { render 'categories_tree' }
    end

  end

  def new
    @cat = Category.new

    flash["msg_#{@cat.id}"] = ''
    flash["msg_cat_new"] = ''

    respond_to do |format|
      format.js { render 'form_new' }
    end
  end

  def create
    @cat = Category.new(category_params)
    @cats = Category.where(parent_id: nil).order(:identifier)
    if @cat.save
      flash["msg_#{@cat.id}"] = 'Categoria criada'
      partial = 'form_edit'
    else
      flash["msg_#{@cat.id}"] = ''
      partial = 'form_new'
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_category', partial: partial),
          turbo_stream.replace('adm_categories_itens', partial: 'category_tree_items')
        ]
      end
    end

  end

  def edit
    @cat = Category.find(params[:category_id])

    flash["msg_#{@cat.id}"] = ''
    flash["msg_cat_new"] = ''

    respond_to do |format|
      format.js { render 'form_edit' }
    end
  end

  def update
    @cat = Category.find(params[:category_id])
    @cats = Category.where(parent_id: nil).order(:identifier)

    if @cat.update(category_params)
      flash["msg_#{@cat.id}"] = 'Registro Gravado'
    else
      flash["msg_#{@cat.id}"] = ''
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('form_category', partial: 'form_edit'),
          turbo_stream.replace('adm_categories_itens', partial: 'category_tree_items')
        ]
      end
    end
  end

  def remove_category
    @cat = Category.find(params[:category_id])

    if @cat.present? && @cat.category_posts.count == 0
      @category_id = @cat.id
      @cat.delete
      render 'category_removed'
    end

  end


  private

  def category_params
    params.require(:category).permit(:nome, :parent_id)
  end

  def can_access
    unless user_signed_in? && current_user.user_level <= 2
      redirect_to admin_path
    end
  end


  def track_action
    ahoy.track "Category action", request.path_parameters
  end
end
