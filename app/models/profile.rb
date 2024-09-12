class Profile < ApplicationRecord

  STR_FORMAT = /\A([a-zA-Zà-úÀ-Ú0-9]|_|-|'| |,|;|.|)+\z/
  NAME_REGEXP = /\A([a-zA-Zà-úÀ-Ú0-9]|-|'|.| |)+\z/
  URL_FORMAT = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/

  
  belongs_to :user
  
  
  validates_presence_of :nickname
  validates_presence_of :identifier
  
  validates_length_of :nickname, within: 3..64, alow_blank: false
  validates_format_of :nickname, with: NAME_REGEXP 
  
  validates_length_of :bio, within: 0..512, allow_blank: true;

  #validates_format_of :site, with: URL_FORMAT, allow_blank: true
  
  #validates_length_of :addres, within: 0..256, allow_blank: true
  #validates_length_of :number, within: 0..16, allow_blank: true
  #validates_length_of :complement, within: 0..256, allow_blank: true
  #validates_length_of :cep, within: 8..10, allow_blank: true
  
  before_create :set_identifier
  
  has_one_attached :profile_picture
  has_many_attached :attachment
  
  
  has_many :attachment_info
  
  validates :attachment, size: { less_than: 5.megabytes, message: 'É muito grande, máximo 5MB' }, content_type: { in: [:png, :jpg, :jpeg, :mov, :mp4, :avi, :mpeg, :pdf], message: 'Formato não permitido' } #, attached: true
  
  
  
  
  has_many :notify
  
  
  
  def set_identifier
    
    l = self.nickname.parameterize
    regex = '^('+l+')(-\d+)?$'
    
    c = Profile.where('identifier ~* ?', regex).count
    self.identifier = (c == 0 ? l : l+'-'+c.to_s)
    
  end
  
  
=begin  
  def picture_type_size
    if self.profile_picture.present?
      if !profile_picture.content_type.in?(%('image/jpeg image/png image/gif'))
        errors.add(:profile_picture, "Formato inválido. Escolha JPG, PNG ou GIF")
      end
      if profile_picture.byte_size > 5.megabytes
        errors.add(:profile_picture, "É muito grande. Limite 10MB.")
      end
    end
  end

 
  def attachment_type_size
    if self.attachments.present?
      att = self.attachments
      p '*****************'
      p att
      p att.blob
      if att.content_type.in?(%('image/jpeg image/png image/gif application/pdf video/mov video/mp4 video/avi video/mpeg'))
        errors.add(:attachments, 'Formato de arquivo inválido.')
      end 
      if att.content_type.in?(%('image/jpeg image/png image/gif application/pdf)) && att.byte_size > 1.megabytes 
        errors.add(:attachments, 'É muito grande. Limite 5MB')
      end
      if att.content_type.in?(%('video/mov video/mp4 video/avi video/mpeg')) && att.byte_size > 15.megabytes
        errors.add(:attachments, 'É muito grande. Limite 15MB' )
      end
    end
  end
=end

  
end
