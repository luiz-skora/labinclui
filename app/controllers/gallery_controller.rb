class GalleryController < ApplicationController

  before_action :can_access, except: [:load_att]

  PERPAGE = 30

  def select_att
    @blob = ActiveStorage::Blob.find(params[:blob_id])

    if params[:multiple] == 'true'
      if params[:add] == 'add'
        render 'gallery/select_append_attachement'
      else
        render 'gallery/select_remove_attachement'
      end
    else
      if params[:add] == 'add'
        render 'gallery/select_update_attachment'
      else
        render 'gallery/select_remove_attachement'
      end
    end
  end

  def load_att


  end

  def tiny_show_modal
    @page = 0
    @query = ''

    @target = params[:editor_id]

    @atts = get_tiny_attachments(@page, @query)

    @next_page = tiny_next_page_path()

    @new_att = App.first.attachment.new

    @new_path = tiny_new_att_path()

    @att_type = 'image'

    @gallery_submit_button_id = "tiny_editor"

    @select_url = tiny_insert_att_path()

    @app = App.first

    render 'tiny_show_modal'
  end

  def tiny_next_page
    @page = params[:page].to_i
    @query = params[:query]

    @atts = get_tiny_attachments(@page, @query)

    html = render_to_string(partial: 'gallery/thumbs')

    render json: { html: html, more: @more, query: @query, page: @page + 1 }
  end

  def tiny_filter
    @page = 0
    @query = params[:query]

    @atts = get_tiny_attachments(@page, @query)

    render 'tiny_filter'
  end

  def tiny_new_att
    @app = App.first
    @new_att = App.first.attachment.new
    @new_path = tiny_new_att_path()
    @att_type = params[:att_type]
    #begin
      file = ActiveStorage::Blob.find_signed!(params[:attachment][:attachment])
      filename = file.filename

      new_file = helpers.proccess_attachment(file)
      if new_file.present?
        blob = ActiveStorage::Blob.create_and_upload!(io: File.open(new_file), filename: filename )
      else
        blob = file
      end
      if ActiveStorage::Attachment.find_or_create_by(name: 'attachment', record_type: 'App', record_id: 1, blob_id: blob.id)
        @att = @app.attachment.find_by(blob_id: blob.id)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace('gallery-add-attachment', partial: 'gallery/form_attachment'),
              turbo_stream.replace('new-attachment', partial: 'gallery/thumb')
            ]
          end
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace('gallery-add-attachment', partial: 'gallery/form_attachment'),
              turbo_stream.replace('new-attachment', partial: 'gallery/thumb_error')
            ]
          end
        end
      end
    #rescue
     # flash[:error] = 'Falha no processamento do arquivo anexado.'
     # respond_to do |format|
     #     format.turbo_stream do
     #       render turbo_stream: [
     #         turbo_stream.replace('gallery-add-attachment', partial: 'gallery/form_attachment'),
     #         turbo_stream.replace('new-attachment', partial: 'gallery/thumb_error')
     #       ]
     #     end
     #   end
    #end
  end

  def tiny_insert_att

    @blob = ActiveStorage::Blob.find(params[:blob_id])

    if @blob.present?
      html = render_to_string(partial: 'gallery/tiny_insert_att')
    else
      html = '<div class="msg"> Não foi possivel exibir o arquivo.</div>'
    end
    render 'tiny_insert_att', locals: { html: html }
  end

  def pagemaker_image
    @page = 0
    @query = ''
    @target = params[:target]

    @atts = get_tiny_attachments(@page, @query)
    @next_page = tiny_next_page_path()
    @app = App.first
    @new_att = @app.attachment.new
    @new_path = tiny_new_att_path()
    @att_type = 'image'
    @gallery_submit_button_id = 'pagemaker_image'
    @select_url = pagemaker_select_image_field_path(@target)

    @modal_id = 'over-1'
    render 'pagemaker_gallery_modal'
  end

  def pagemaker_pdf
    @page = 0
    @query = ''
    @target = params[:target]

    @atts = get_tiny_attachments(@page, @query)
    @next_page = tiny_next_page_path()
    @app = App.first
    @new_att = @app.attachment.new
    @new_path = tiny_new_att_path()
    @att_type = 'pdf'
    @gallery_submit_button_id = 'pagemaker_file_pdf'
    @select_url = pagemaker_select_file_pdf_field_path(@target)

    @modal_id = 'over-1'
    render 'pagemaker_gallery_modal'
  end

    def show_pdf
    p '**** SHOW PDF'
    @blob = ActiveStorage::Blob.find(params[:pdf_blob_id])
    if @blob.present? && @blob.content_type == 'application/pdf'
      p '*** BLOB PRESENT '
      @url = rails_blob_path(@blob)
      p '****************'
      p @url
      render 'show_pdf', layout: false
    else
      p '*** NOT FOUND ****'
      render 'not_found'
    end
  end

  private

  def can_access
    unless user_signed_in?
      redirect_to root_path
    end
  end

  def get_tiny_attachments(page, query)
    if query.blank?
      lista = ActiveStorage::Attachment.where(name: 'attachment').where(record_type: 'App').order(created_at: :desc).offset(PERPAGE * page).limit(PERPAGE)
      @count = ActiveStorage::Attachment.where(name: 'attachment').where(record_type: 'App').count
    else
      blobs = ActiveStorage::Blob.where("filename ILIKE '%#{query}%'").ids
      lista = ActiveStorage::Attachment.where(blob_id: blobs).where(name: 'attachment').where(record_type: 'App').order(created_at: :desc).offset(PERPAGE * page).limit(PERPAGE)
      @count = ActiveStorage::Attachment.where(blob_id: blobs).where(name: 'attachment').where(record_type: 'App').count
    end

    @more = ( @count > (PERPAGE * (page + 1)) ? 1 : 0 )

    return lista
  end

  def new_att_params
    params.require(:blob).permit(:attachment)
  end


end
