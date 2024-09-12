class EvaluationQuestion < ApplicationRecord
  belongs_to :modulo_evaluation

  has_rich_text :enunciado

  has_many :question_alternative, dependent: :destroy

  validates_presence_of [:indice, :tipo, :peso], allow_blank: false

  def reindex_alternatives
    alternatives = self.question_alternative.order(:indice, :id)
    alternatives.each_with_index do |k, i|
      k.update(indice: i + 1)
    end
  end
end
