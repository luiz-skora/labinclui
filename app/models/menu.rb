class Menu < ApplicationRecord
  belongs_to :app

  has_many :menu_item, dependent: :destroy

  validates_presence_of :nome, allow_blank: false

  validates_uniqueness_of :identifier

  before_create do |t|
    l = t.nome.parameterize.tr(' ','-')
    regex = '^('+l+')(-\d+)?$'
    c = Menu.where('identifier ~* ?', regex ).count
    t.identifier = ( c == 0 ? l : l+'-'+c.to_s )
  end

end
