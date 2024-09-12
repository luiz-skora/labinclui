class QuestionAlternative < ApplicationRecord
  belongs_to :evaluation_question

  has_rich_text :alternative

  #validates_presence_of :indice, allow_blank: false

  validate :validate_words

  def validate_words
    if self.min_words.present? && self.max_words.present?
      errors.add(:min_words, 'Deve ser menor que o número máximo de palavras.') unless self.min_words < self.max_words

      errors.add(:max_words, 'Deve ser maior que o número mínimo de palavras.') unless self.max_words > self.min_words
    end
  end

  before_create :set_is_discursiva

  def set_is_discursiva
    self.is_discursiva = ( self.evaluation_question.tipo == 'Discursiva' ? true : false )
  end
end
