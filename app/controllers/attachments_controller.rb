class AttachmentsController < ApplicationController

  def google_doc_view
    @google_id = params[:id]

    render 'google_doc_view', layout: false
  end
end
