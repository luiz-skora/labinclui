require 'nokogiri'
module PostHelper

  def prepare_edit(content)
    html = content.to_trix_html
    nodes = Nokogiri.HTML(html)
    images = nodes.xpath('//figure')

    images.each do |figure|
      sgid = figure.attr('data-att')
      if sgid.present?
        img = figure.at_css('img')
        if img.present?
          img.set_attribute('src', url_for(ActiveStorage::Blob.find_signed(sgid)))
        end
      end
    end

    return nodes.to_html
  end


end
