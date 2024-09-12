class App < ApplicationRecord

  has_many_attached :attachment

  has_many :attachment_info

  has_many :page

  has_many :area

  has_many :site_menu

  has_many :pagemaker_component

  has_many :ad

  has_many :menu

  has_one :front_style

  has_one :front_script

  validates :attachment, size: { less_than: :attachments_max_size, message: "É muito grande. Tamanho máximo permitido: #{ActionController::Base.helpers.number_to_human_size(:attachments_max_size)}"}, content_type: { in: [:png, :jpg, :jpeg, :mov, :mp4, :avi, :mpeg, :pdf], message: 'Formato não permitido' } #, attached: true


  def attachments_max_size
    ConfGrupo.find_by(nome: 'Admin').conf.find_by(nome: 'upload_max_size').valor.to_i.megabytes rescue 15.megabytes
  end

end
