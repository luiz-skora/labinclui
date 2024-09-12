class Area < ApplicationRecord


  belongs_to :app
  belongs_to :parent, class_name: 'Area', optional: true
  has_many :children, class_name: 'Area', foreign_key: :parent_id

  scope :get_childrens, -> (parent) { where(parent_id: parent )}

  has_rich_text :content

  validates_presence_of :nome, allow_bkank: false

  validates_uniqueness_of :identifier

  before_create :set_identifier

  after_save :clear_cache

  def set_identifier
    if self.identifier.blank?
      l = self.nome.parameterize

      regex = '^('+l+')(-\d+)?$'

      c = Area.where('identifier ~* ?', regex).count
      self.identifier = ( c == 0 ? l : l+'-'+c.to_s )
    end
  end

  #before_save :clear_content_components

  def clear_content_components
    require "nokogiri"
    content = Nokogiri.HTML(self.content.body.to_trix_html)
    pms = content.css('.pm-component')

    pms.each do |pm|
      pm.children.remove
      pm.children.remove
      pm.add_child '<div class="component_loading" style="height: 100vh"></div>'
    end

    self.content.body = content.to_html

  end


end
