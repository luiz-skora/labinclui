class PagemakerComponent < ApplicationRecord

  #https://dev.to/paramagicdev/all-the-ways-to-render-an-actiontext-attachment-1jo4

  include ActionText::Attachable
  require 'json'
  belongs_to :app

  has_one_attached :att




  def to_trix_content_attachment_partial_path
    p '***********************************'
    p 'to_trix_content_attachment_partial_path'
    if self.pagemaker_identifier == 'colunas'
      "pagemaker_components/pagemaker_columns"
    else
      "pagemaker_components/pagemaker_component"
    end
  end

  def to_attachable_partial_path
    p '***********************************'
    p 'to_attachable_partial_path'

    if self.pagemaker_identifier == 'colunas'
      "pagemaker_components/pagemaker_columns"
    else
      "pagemaker_components/view_component"
    end
    #tira o preview do nome da partial e, por exemplo, bota o link na logo
  end

end
