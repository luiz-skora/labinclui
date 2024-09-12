class ModuloEvaluation < ApplicationRecord
  belongs_to :curso_modulo

  has_many :evaluation_question

  def reindex_questions
    questions = self.evaluation_question.order(:indice, :id)
    questions.each_with_index do |k, i|
      k.update(indice: i + 1)
    end
  end
end
