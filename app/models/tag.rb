class Tag < ApplicationRecord

  #has_many :tag_posts
  #has_many :posts, through: :tag_posts

  has_and_belongs_to_many :posts

  validates_presence_of :nome, allow_blank: false

  before_create :set_identifier

  def set_identifier
    l = self.nome.parameterize
    regex = '^('+l+')(-\d+)?$'

    c = Tag.where('identifier ~* ?', regex).count
    self.identifier = ( c == 0 ? l : l+'-'+c.to_s )
  end

  def mount_url
    parent = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(nome: 'Base de Tags').valor rescue 'tag'
    "/#{parent}/#{self.identifier}"
  end

end
