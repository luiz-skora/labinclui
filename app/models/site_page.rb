class SitePage < ApplicationRecord
  belongs_to :app

  has_rich_text :content

  validates_presence_of :titulo, allow_blank: false

  before_create do |t|
    l = t.titulo.parameterize.tr(' ','-')
    regex = '^('+l+')(-\d+)?$'
    c = SitePage.where('route ~* ?', regex ).count
    t.route = ( c == 0 ? l : l+'-'+c.to_s )
  end
end
