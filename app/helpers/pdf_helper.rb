module PdfHelper

  def get_pdf_iframe(att_id, width = "100%", height = "100%")
    blob = ActiveStorage::Blob.find(att_id)
    if blob.present? && blob.content_type == 'application/pdf'
      result = %(<iframe title="Documento PDF", width="#{width}" height="#{height}" src="#{pdfjs.full_path(file: rails_blob_path(blob))}")

      #funciona bem, mas não tem ferramentas
      #result = content_tag :embed, '', src: rails_blob_path(blob), type: 'application/pdf', width: '100%', height: '100%'

      result.html_safe
    else
      result ''
    end
  end

end
