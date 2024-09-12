class AulaPagina < ApplicationRecord
  belongs_to :modulo_aula

  has_rich_text :content
end
