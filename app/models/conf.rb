class Conf < ApplicationRecord
  belongs_to :conf_grupo
  
  has_one_attached :attachment
end
