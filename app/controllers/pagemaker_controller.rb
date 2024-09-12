class PagemakerController < ApplicationController

  layout "admin"

  before_action :can_access



  def show_components_dialog

    if params.has_key?(:pm_id)
      @components = Pagemaker.order(:component)
      @element = ActionText::Attachable.from_attachable_sgid(params[:sgid])
      if @element.present?
        @component = Pagemaker.find_by(identifier: @element.pagemaker_identifier)
        @fields = @element.fields.symbolize_keys
        render 'edit_component_modal'
      end
    else
      helpers.initialize_pagemaker_components
      @components = Pagemaker.order(:component)
      render 'components_modal'
    end
  end

  def setup_component

    @component = Pagemaker.find(params[:pagemaker_id])
    @fields = Hash[*@component.pagemaker_field.collect{|k| [k.label, k.default_value]}.flatten].symbolize_keys
    @preview = true

    @fields.store(:pm_ident, @component.identifier)

    @fields = helpers.initialize_component_fields(@fields)

    render 'setup_component'
  end

  def edit_setup_component

    @components = Pagemaker.order(:component)

    @component = Pagemaker.find(params[:pagemaker_id])
    @fields = JSON.parse(params[:fields]).symbolize_keys

    @fields.store(:pm_ident, @component.identifier)

    render 'setup_edit_component'
  end

  def preview_component
    @component = Pagemaker.find(params[:pagemaker_id])
    @preview = true
    fields = JSON.parse(params[:fields]).symbolize_keys

    fields.store(:pm_ident, @component.identifier )

    html = ApplicationController.render(partial: "#{@component.html_base}_preview", locals: { fields: fields} )

    render json: { html: html, fields: fields.to_json }
  end

  def insert_component
    @component = Pagemaker.find(params[:pagemaker_id])
    @editor_id = params[:editor_id]

    @fields = JSON.parse(params[:fields]).symbolize_keys

    @component_data = App.first.pagemaker_component.find_or_create_by(pagemaker_identifier: @component.identifier, fields: @fields )

    #@html = ApplicationController.render(partial: "#{@component.html_base}_preview", locals: { fields: @fields})

    render 'insert_component'

  end

  def update_component
    @component = Pagemaker.find(params[:component_id])
    @editor_id = params[:editor_id]

    @fields = JSON.parse(params[:fields]).symbolize_keys
    @fields[:pm_ident] = @component.identifier

    @component_data = App.first.pagemaker_component.find_or_create_by(pagemaker_identifier: @component.identifier, fields: @fields)

    #@html = ApplicationController.render(partial: "#{@component.html_base}", locals: { fields: @fields})

    @html = render_to_string(partial: "#{@component.html_base}", locals: { fields: @fields},  layout: false)

    p 'html ***********'
    p @html

    render 'update_component', locals: { fields:  (@fields.select{|k,v| !v.blank?}).to_json }

  end

  #colunas
  def show_columns_dialog
    if params[:columns_id].blank?
      @fields = { colunas: 2, alinhamento: 'centro', classe: ''}
    else
      @fields = JSON.parse(params[:columns_data]).symbolize_keys
    end
    render 'columns_modal'
  end

  def change_number_columns
    @fields = { colunas: params[:cols].to_i}
    render 'change_number_columns'
  end

  def preview_columns
    @fields = JSON.parse(params[:fields]).symbolize_keys

    html = ApplicationController.render(partial: 'pagemaker/columns_preview', locals: {fields: @fields})

    render json: { html: html, fields: @fields.to_json }
  end

  def insert_columns
    @editor_id = params[:editor_id]

    @fields = JSON.parse(params[:fields]).symbolize_keys

    #@component_data = App.first.pagemaker_component.find_or_create_by(pagemaker_identifier: 'colunas', fields: @fields )

    if params[:component_id].blank?

      render 'insert_columns'
    else
      p '**** @fields *****'
      p @fields


      render 'update_columns', locals: { fields:  (@fields.select{|k,v| !v.blank?}).to_json }
    end
  end

  #imagem
  def select_image_field
    @image_field = params[:pagemaker_id]
    @blob = ActiveStorage::Blob.find(params[:blob_id])

    render 'update_image_field'
  end

  def select_file_pdf_field
    @file_pdf_field = params[:pagemaker_id]
    @blob = ActiveStorage::Blob.find(params[:blob_id])

    render 'update_file_pdf_field'
  end

  private

  def can_access
    unless user_signed_in? && current_user.user_level <= 2
      redirect_to admin_path
    end
  end

end
