class Pagemaker < ApplicationRecord
  has_many :pagemaker_field, dependent: :destroy

  validates_presence_of :component, allow_blank: false

  validates_uniqueness_of :identifier

  before_create :set_identifier

  def set_identifier
    if self.identifier.blank?
      l = self.component.parameterize

      regex = '^('+l+')(-\d+)?$'

      c = Pagemaker.where('identifier ~* ?', regex).count
      self.identifier = ( c == 0 ? l : l+'-'+c.to_s )
    end
  end
end

=begin
<%= content_tag :div, class: 'pm-component-edit' do %>
  <ul class="pm-edit-buttons">
    <%= content_tag :li, far_icon('edit'), title: 'Editar', class: 'pm-edit-lnk', data: { url: '#', fields: component.fields.to_json, component: pm.identifier} %>
  </ul>
<% end %>
=end
