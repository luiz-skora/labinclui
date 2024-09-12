class Curso < ApplicationRecord

  NAME_REGEXP = /\A([a-zA-Zà-úÀ-Ú]|-|'|.| |)+\z/

  validates_presence_of :nome, :coordenador, :horas, :tipo
  validates_length_of :nome, within: 4..128, allow_blank: false
  validates_format_of :nome, with: NAME_REGEXP
  validates :horas, numericality: { only_integer: true, in: 1..3600 }

  has_rich_text :content

  has_many :curso_modulo

  before_create :set_identifier

  def set_identifier
    if self.identifier.blank?
      l = self.nome.parameterize

      regex = '^('+l+')(-\d+)?$'

      c = Curso.where('identifier ~* ?', regex).count
      self.identifier = ( c == 0 ? l : l+'-'+c.to_s )
    end
  end

  def coordenador
    User.find(self.coordenador_id) rescue nil
  end
end
