class AdmMyProfileController < ApplicationController

  layout "admin"

  PERPAGE = 2

  before_action :can_access
  before_action :can_change, except: :show

  after_action :track_action

  def show
    render 'show'
  end

  def edit
    flash[:msg] = ''
    render "edit_my_profile"
  end

  def update
    if @profile.update(my_profile_params)
      flash[:msg] = 'Registro Gravado'
    else
      flash[:msg] = ''
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('my-profile-form', partial: 'form_fields') }
    end

  end

  def gallery_modal
    @page = 0
    @query = ''

    @target = params[:target]

    @atts = get_profile_attachments(@page, @query)

    @new_att = @profile.attachment.new
    @new_path = adm_my_profile_add_attachment_path(@profile.identifier)
    @next_page = adm_my_profile_next_page_gallery_path(@profile.identifier)
    @att_type = 'image'

    render 'profille_attachments_modal'
  end

  def next_page_gallery
    @page = params[:page].to_i
    @query = eval(params[:query].to_s)

    @atts = get_profile_attachments(@page, @query)

    html = render_to_string(partial: 'gallery/thumbs')

    render json: { html: html, more: @more, query: @query.to_s, page: @page + 1 }
  end

  def add_attachment

    if @profile.attachment.attach(params[:attachment][:attachment])
      @profile.profile_picture.attach(params[:attachment][:attachment])
      @new_att = @profile.attachment.new
      @new_path = adm_my_profile_add_attachment_path(@profile.identifier)
      @att_type = 'image'
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('gallery-add-attachment', partial: 'gallery/form_attachment'),
            turbo_stream.replace('new-attachment', partial: 'gallery/thumb', locals: { att: ActiveStorage::Blob.find_signed!(params[:attachment][:attachment]) })
            ]
        end
      end
    else
      p 'NOT ATTACHED'
    end

  end

  def change_profile_picture
    @profile.profile_picture.attach(ActiveStorage::Blob.find(params[:blob_id]))

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
        [
          turbo_stream.replace('edit-profile-picture', partial: 'edit_profile_picture'),
          turbo_stream.replace('modal-window', partial: 'shared/modal'),
          turbo_stream.replace('profile-gravatar', partial: 'shared/profile_gravatar')
        ]
      end
    end
  end

  private

  def can_access
    @profile = Profile.find_by(identifier: params[:profile_identifier])

    @user = @profile.user
    @current_profile =  @profile.id == current_user.profile.id ? true : false
    unless user_signed_in? && current_user.user_level <= 1
      redirect_to admin_path
    end
  end

  def can_change

    unless @current_profile
      redirect_to adm_my_profile_show_path(@profile.identifier)
    end
  end

  def get_profile_attachments(page, query)
    if query.blank?
      lista = @profile.attachment.order(created_at: :desc).offset(PERPAGE * page).limit(PERPAGE)
      @count = @profile.attachment.count
    else
      lista = nil
      @count = 0
    end

    @more = ( @count > (PERPAGE * (page + 1)) ? 1 : 0 )

    return lista

  end

  def my_profile_params
    params.require(:profile).permit(:nickname, :bio, :site)
  end

  def track_action
    ahoy.track "my profile action", request.path_parameters
end
