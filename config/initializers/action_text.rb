# white list the attribute style for action text. e.g. <tag_name style="">
ActionText::Attachment::ATTRIBUTES << "style"
ActionText::Attachment::ATTRIBUTES << "data-controller"
ActionText::Attachment::ATTRIBUTES << "data-action"

ActionText::Attachment::ATTRIBUTES << "data-visitor-target"
ActionText::Attachment::ATTRIBUTES << "data-view-url"
ActionText::Attachment::ATTRIBUTES << "data-sgid"
ActionText::Attachment::ATTRIBUTES << "sgid"
ActionText::Attachment::ATTRIBUTES << "data-att"
ActionText::Attachment::ATTRIBUTES << "data-sharepost-url-value"
ActionText::Attachment::ATTRIBUTES << "data-sharepost-title-value"
ActionText::Attachment::ATTRIBUTES << "data-sharepost-body-value"
ActionText::Attachment::ATTRIBUTES << "data-sharepost-share-value"
ActionText::Attachment::ATTRIBUTES << "data-sharepost-button-value"
ActionText::Attachment::ATTRIBUTES << "data-sharepost-device-value"
ActionText::Attachment::ATTRIBUTES << "class"
ActionText::Attachment::ATTRIBUTES << "id"
ActionText::Attachment::ATTRIBUTES << "data-images-url-value"
ActionText::Attachment::ATTRIBUTES << "data-index"
ActionText::Attachment::ATTRIBUTES << "data-id"
ActionText::Attachment::ATTRIBUTES << "data-pmslider-url-value"
ActionText::Attachment::ATTRIBUTES << "data-pmslider-target-value"
ActionText::Attachment::ATTRIBUTES << "data-pmslider-refresh-interval-value"
ActionText::Attachment::ATTRIBUTES << "data-title"
ActionText::Attachment::ATTRIBUTES << "data-img"
ActionText::Attachment::ATTRIBUTES << "data-url"
ActionText::Attachment::ATTRIBUTES << "data-via"
ActionText::Attachment::ATTRIBUTES << "rel"
ActionText::Attachment::ATTRIBUTES << "data-site"
ActionText::Attachment::ATTRIBUTES << "onclick"
ActionText::Attachment::ATTRIBUTES << "title"
ActionText::Attachment::ATTRIBUTES << "type"
ActionText::Attachment::ATTRIBUTES << "data-toggle"
ActionText::Attachment::ATTRIBUTES << "data-target"
ActionText::Attachment::ATTRIBUTES << "aria-controls"
ActionText::Attachment::ATTRIBUTES << "aria-expanded"
ActionText::Attachment::ATTRIBUTES << "aria-label"


# allow additional tags in custom attachments.
ActionText::ContentHelper.allowed_tags += ['table', 'tr', 'td', 'ul', 'li', 'pm_row', 'pm_col', 'i', 'svg', 'alt', 'form', 'label', 'nav', 'button', 'span', 'path']

ActionText::ContentHelper.allowed_tags.add 'a'
ActionText::ContentHelper.allowed_tags.add 'p'

#exibição de conteúdo em iframe
ActionText::ContentHelper.allowed_tags.add 'iframe'
ActionText::ContentHelper.allowed_attributes += ['width', 'height', 'src', 'title', 'frameborder', 'allow', 'allowfullscreen']
##### brexa de segurança necessária para exibição de anúncios script ####
ActionText::ContentHelper.allowed_tags.add 'script'
ActionText::ContentHelper.allowed_attributes.add 'async'
# anúncio google
ActionText::ContentHelper.allowed_attributes.add 'data-ad-client'
ActionText::ContentHelper.allowed_attributes.add 'data-ad-slot'

#font-awessome SVG code
ActionText::ContentHelper.allowed_attributes.add 'data-direction'
ActionText::ContentHelper.allowed_attributes.add 'focusable'
ActionText::ContentHelper.allowed_attributes.add 'data-prefix'
ActionText::ContentHelper.allowed_attributes.add 'data-icon'
ActionText::ContentHelper.allowed_attributes.add 'role'
ActionText::ContentHelper.allowed_attributes.add 'viewbox'
ActionText::ContentHelper.allowed_attributes.add 'data-fa-i2svg'


ActionText::ContentHelper.allowed_attributes.add 'class'
ActionText::ContentHelper.allowed_attributes.add 'data-fields'
ActionText::ContentHelper.allowed_attributes.add 'data-view-url'
ActionText::ContentHelper.allowed_attributes.add 'data-sgid'
ActionText::ContentHelper.allowed_attributes.add 'id'
ActionText::ContentHelper.allowed_attributes.add 'data-visitor-target'
ActionText::ContentHelper.allowed_attributes.add 'href'
ActionText::ContentHelper.allowed_attributes.add 'title'

#svg icons
ActionText::ContentHelper.allowed_attributes.add 'aria-hidden'
ActionText::ContentHelper.allowed_attributes.add 'role'
ActionText::ContentHelper.allowed_attributes.add 'xmlns'
ActionText::ContentHelper.allowed_attributes.add 'viewBox'
ActionText::ContentHelper.allowed_attributes.add 'fill'
ActionText::ContentHelper.allowed_attributes.add 'd'

