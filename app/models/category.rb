class Category < ApplicationRecord

  #has_many :category_posts
  #has_many :posts, through: :category_posts

  has_and_belongs_to_many :posts

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: :parent_id

  scope :get_childrens, -> (parent) { where(parent_id: parent )}

  validates_presence_of :nome, allow_blank: false

  validates_uniqueness_of :nome

  validates_uniqueness_of :identifier

  has_rich_text :desciption

  before_create :set_identifier


  def set_identifier
    l = self.nome.parameterize
    regex = '^('+l+')(-\d+)?$'

    c = Category.where('identifier ~* ?', regex).count
    self.identifier = ( c == 0 ? l : l+'-'+c.to_s )
  end

  def get_posts(limit=100)

    self.posts.order(published_in: :desc).limit(limit)


  end

  def mount_url
    parent = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(nome: 'Base de Categorias').valor rescue 'categoria'
    "/#{parent}/#{self.identifier}"
  end

end
