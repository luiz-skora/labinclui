class User < ApplicationRecord
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})\Z/i
  NAME_REGEXP = /\A([a-zA-Zà-úÀ-Ú]|-|'|.| |)+\z/
  LOGIN_REGEXP = /\A([a-z0-9]|-|_|)+\z/ 
  
  has_many :login_log
  
  has_many :aluno_historico
  
  has_many :aluno_curso_status
  
  has_many :notify
  
  has_one :profile, dependent: :destroy
  
  scope :confirmed, -> { where.not(confirmation_at: nil) }
  
  validates_presence_of :nome, :email, :nascimento
  validates_length_of :nome, within: 4..128, allow_blank: false
  validates_length_of :email, within: 5..128, allow_blank: false
  validates_uniqueness_of :login, :email, case_sensitive: false
  validates_format_of :email, with: EMAIL_FORMAT
  validates_format_of :nome, with: NAME_REGEXP
  
  validate :password_changed
  
  
  def password_changed
    if password_digest_changed?
      
      errors.add(:password, 'Mínimo 6 caracteres') unless password.length >= 6 &&  password.length <= 72
    end
  end
  #validates_length_of :password, within: 6..72 #, :if => { :password.present? }
  
  validates :terms_acpetd, acceptance: true
  
  has_secure_password
  
  
  has_secure_token :token
  has_secure_token :recovery_token
  
  accepts_nested_attributes_for :profile
  
  #before_create :generate_password
  #def generate_password
  #  self.password = rand(36**12).to_s(36)
  #  self.password_confirmation = self.password
  #end
  
  #after_create :confirm_email
  #def confirm_email
  #  Signup.confirm_email(self).deliver_later
  #end
  
  
  validate :nascimento_value
  
  def nascimento_value
    errors.add(:nascimento, 'fora do intervalo válido') unless  nascimento.present? && ( nascimento < Date.current && nascimento >= Date.current.years_ago(120) ) 
  end
  
  before_create do |t|        
    l = t.nome.parameterize.tr(' ','-')
    regex = '^('+l+')(-\d+)?$'
    c = User.where('login ~* ?', regex ).count
    t.login = ( c == 0 ? l : l+'-'+c.to_s )
  end
  
  after_create :create_profile
  def create_profile
    Profile.create do |f|
      f.user_id = self.id
      f.nickname = "#{self.nome}"
      f.tipo = 'person'
      f.identifier = f.set_identifier
      f.save
    end
    
    if self.login != self.profile.identifier
      self.login = self.profile.identifier
      self.save
    end
  end
  
  def confirm!
    return if confirmed?
    
    self.confirmation_at = Time.current
    self.token = ''
    save!
  end
  
  def confirmed?
    confirmation_at.present?
  end
  
  def self.authenticate(email, password)
    user = confirmed.find_by(email: email)
    
    if user.present?
      user.authenticate(password)
    end
  end

 
  def generate_recovery_token
    regenerate_recovery_token
  end  
  
  
end
