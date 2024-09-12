class MenuItem < ApplicationRecord
  belongs_to :menu

  #parent/child
  belongs_to :parent, class_name: 'MenuItem', optional: true
  has_many :children, class_name: 'MenuItem', foreign_key: :parent_id

  validates_presence_of :nome, allow_blank: false
  validates_presence_of :link, allow_bkank: false, if: -> { self.tipo == 'url' }
  validates_presence_of :rota, allow_bkank: false, if: -> { self.tipo == 'pagina' }

  def get_childrens
    MenuItem.where(parent_id: self.id )
  end

  def has_childrens?
    MenuItem.where(parent_id: self.id).present?
  end

  def mount_url
    case self.tipo
    when 'url'
      self.link
    when 'pagina'
      parent = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(nome: 'Base de páginas').valor rescue 'pagina'
    "/#{parent}/#{self.rota}"
    else
      '#'
    end
  end
end
