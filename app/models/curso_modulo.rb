class CursoModulo < ApplicationRecord
  belongs_to :curso

  NAME_REGEXP = /\A([a-zA-Zà-úÀ-Ú]|-|'|.| |)+\z/

  belongs_to :curso

  validates_presence_of :nome, :coordenador_id
  validates_length_of :nome, within: 4..128, allow_blank: false
  validates_format_of :nome, with: NAME_REGEXP

  has_rich_text :content

  has_many :modulo_aula

  has_many :modulo_evaluation

  before_create :reindex_indice

  def reindex_indice
    indice = self.indice
    modulos = Curso.find(self.curso.id).curso_modulo.order(:indice, :id)
    modulos.each_with_index do |m, i|
      if m.indice.present? && m.indice >= indice
        m.update(indice: indice + i + 1)
      end
    end
  end

  def coordenador
    User.find(self.coordenador_id) rescue nil
  end

end
