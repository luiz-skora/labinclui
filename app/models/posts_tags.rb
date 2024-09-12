class PostsTags < ApplicationRecord

  belongs_to :tag
  belongs_to :post

end
