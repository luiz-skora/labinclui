require 'nokogiri'
require 'uri'
require 'open-uri'
require 'logger'

class Post < ApplicationRecord

  #has_many :category_posts
  #has_many :categories, through: :category_posts

  has_and_belongs_to_many :categories

  #has_many :tag_posts
  #has_many :tags, through: :tag_posts

  has_and_belongs_to_many :tags

  has_rich_text :content

  has_rich_text :resumo

  has_many_attached :attachment

  has_one_attached :featured_image

  validates_presence_of :titulo, allow_blank: false

  validates_uniqueness_of :identifier

  before_create :set_identifier

  def set_identifier
    if self.identifier.blank?
      l = self.titulo.parameterize

      regex = '^('+l+')(-\d+)?$'

      c = Post.where('identifier ~* ?', regex).count
      self.identifier = ( c == 0 ? l : l+'-'+c.to_s )
    end
  end

  before_save :set_published_in

  def set_published_in
    if self.status == 'publish' && self.origin == 'App'
      if self.published_in.blank?
        self.published_in = DateTime.now
        self.changed_in = DateTime.now
      else
        self.changed_in = DateTime.now
      end
    end
  end

  before_save :save_figures, if: -> { self.origin == 'App' }

  def save_figures

   puts "save figures"

   html = self.content.body.to_trix_html
   nodes = Nokogiri.HTML(html)
   images = nodes.xpath('//figure')

   #insere self.attachment que estiver no conteúdo
   blobs_ids = []
   images.each do |figure|
     puts 'save figure'
     sgid = figure.attr('data-att')
     if sgid.present?
       blob = ActiveStorage::Blob.find_signed(sgid)
       if blob.present?
         blobs_ids << blob.id
         if !self.attachment.pluck(:blob_id).include? blob.id
           self.attachment.attach(blob)
         end
         img = figure.at_css('img')
         if img.present?
           img.set_attribute('src', '/blank.svg')
         end
       end
     end

   end

   #remove self.attachment que não estiver no conteúdo
   self.attachment.each do |att|
     if !blobs_ids.include? att.blob_id
       att.delete
     end
    end

    self.content.body = nodes.to_html
  end


  def mount_url
    parent = ConfGrupo.find_by(nome: 'Navegação').conf.find_by(nome: 'Base de Publicação').valor rescue 'artigo'
    "/#{parent}/#{self.identifier}"
  end

  def related_posts(n=5)
    ids = []
    self.tags.each do |k|
      ids.concat(k.posts.where.not(id: self.id).order(published_in: :desc).limit(n).pluck(:id)).uniq
    end
    Post.where(id: ids).order(published_in: :desc).limit(n)
  end

end
