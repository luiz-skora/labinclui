class ConfGrupo < ApplicationRecord
  has_many :conf
  
  validates_presence_of :nome
  validates_length_of :nome, within: 4..64, allow_blank: false
  validates_uniqueness_of :nome
end
