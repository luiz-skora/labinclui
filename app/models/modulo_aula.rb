class ModuloAula < ApplicationRecord



  belongs_to :curso_modulo

  has_many :aula_pagina, dependent: :destroy

  has_rich_text :content

  has_many_attached :attachments, dependent: :destroy
  validates :attachments, attached: true, size: { less_than: :attachments_max_size, message: "É muito grande. Tamanho máximo permitido: #{ActionController::Base.helpers.number_to_human_size(:attachments_max_size)}"}


  has_many_attached :page_att, dependent: :destroy

  validates_presence_of :nome, :tipo, :indice, allow_blank: false


  before_create :reindex_indice

  def reindex_indice
    indice = self.indice
    aulas = CursoModulo.find(self.curso_modulo_id).modulo_aula.order(:indice, :id)

    aulas.each_with_index do |m, i|
      if m.indice.present? && m.indice >= indice
        m.update(indice: indice + i + 1 )
      end
    end
  end

  def attachments_max_size
    ConfGrupo.find_by(nome: 'Admin').conf.find_by(nome: 'upload_max_size').valor.to_i.megabytes rescue 15.megabytes
  end


end
