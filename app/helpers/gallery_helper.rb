module GalleryHelper

  def load_thumb(att, width, height)
    if att.present?
      if att.image?
        if att.variable?
          image_tag(att.variant(resize_to_limit: [height, width]), data: { file: att.id }, width: width, height: height)
        else
          image_tag(att, height: height, width: width, data: { file: att.id})
        end
      elsif att.video?
        if att.previewable?
          image_tag(att.preview(resize_to_limit: [height, width]))
        else
          image_tag('icons/movie.png', height: height, data: {file: att.id } )
        end
      elsif att.audio?
        image_tag('icons/audio_icon.png', height: height, data: {file: att.id } )
      elsif att.content_type.split('/')[1] == 'pdf'
        if att.previewable?
          image_tag( att.preview(resize_to_limit: [height, width] ), data: {file: att.id } )
        else
          image_tag('icons/pdf-file-type-icon.png', height: height, data: { file: att.id } )
        end
      else
        if att.previewable?
          image_tag( att.preview(resize_to_limit: [height, width] ), data: { file: att.id } )
        else
          image_tag('icons/file.png', height: height, data: { file: att.id } )
        end
      end
    end
  end

  def load_pdf_thumb(att, width, height)
    if att.previewable?
      image_tag( att.preview(resize_to_limit: [height, width] ), data: { file: att.id } )
    else
      image_tag('icons/file.png', height: height, data: { file: att.id } )
    end
  end
  
  def load_blob(blob, width, height, data=false)
    if blob.present?
      if blob.image?
        if blob.variable?
          img = blob.variant(resize_to_limit: [ width, height])
        else
          img = blob

        end
      elsif blob.video?
        if blob.previewable?
          img = blob.preview(resize_to_limit:  [width, height])
        else
          img = 'icons/movie.png'
          #image_tag('icons/movie.png', height: height, data: {file: blob.id }, alt: blob.filename )
        end
      elsif blob.audio?
        img = 'icons/audio_icon.png'
        #image_tag('icons/audio_icon.png', height: height, data: {file: blob.id }, alt: blob.filename )
      elsif blob.content_type.split('/')[1] == 'pdf'
        if blob.previable?
          img = blob.preview(resize_to_limit:  [width, height] )

        else
          img = 'icons/pdf-file-type-icon.png'
          #image_tag('icons/pdf-file-type-icon.png', height: height, data: { file: blob.id }, alt: blob.filename )
        end
      else
        if blob.previewable?
          img = blob.preview(resize_to_limit:  [width, height] )
          #image_tag(img , data: { file: blob.id }, alt: blob.filename )
        else
          img = 'icons/file.png'
          #image_tag('icons/file.png', height: height, data: { file: blob.id }, alt: blob.filename )
        end
      end
    end
    if data
      { url: url_for(img), file: (blob.id rescue 0) , width: width, height: height, alt: (blob.filename rescue '') }
    else
      image_tag(img, data: { file: blob.id }, width: width, height: height, alt: blob.filename )
    end
  end





  def load_site_logo(app_logo, height, width)
    blob = app_logo.attachment rescue nil
    if blob.present? && blob.image? && blob.variable?
      w = width.blank? ? nil : width.to_i
      h = height.blank? ? nil : height.to_i
      if h.present? || w.present?
        image_tag(blob.variant(resize_to_limit: [w, h]), width: w, height: h, alt: 'logo')
      else
        image_tag(blob, width: w, height: h, alt: 'logo')
      end
    end
  end
  
  
  def load_cropped_blob(blob, width, height)
    if blob.present?
      if blob.image?
        if blob.variable?
          image_tag(blob.variant(resize_to_fill: [height, width]), data: { file: blob.id })
        else
          image_tag(blob, height: height, width: width, data: { file: blob.id})
        end
      elsif blob.video?
        if blob.previewable?
          image_tag(blob.preview(resize_to_fill: [height, width]))
        else
          image_tag('icons/movie.png', height: height, data: {file: blob.id } )
        end
      elsif blob.audio?
        image_tag('icons/audio_icon.png', height: height, data: {file: blob.id } )
      elsif blob.content_type.split('/')[1] == 'pdf'
        if blob.previable?
          image_tag( blob.preview(resize_to_fill: [height, width] ), data: {file: blob.id } )
        else
          image_tag('icons/pdf-file-type-icon.png', height: height, data: { file: blob.id } )
        end
      else
        if blob.previewable?
          image_tag( blob.preview(resize_to_fill: [height, width] ), data: { file: blob.id } )
        else
          image_tag('icons/file.png', height: height, data: { file: blob.id } )
        end
      end
    end
  end
  
  
  def proccess_attachment(file)
    
    if file.image?
      path = ActiveStorage::Blob.service.send(:path_for, file.key)
      proce =  ImageProcessing::Vips.source(path).convert("png") #.saver(quality: 30, compression: 2, interlace: false )
      new_file = proce.resize_to_limit!(1200, 1200)
      file.purge
      
      return new_file.path
    else
      return nil
    end
  end
  
  def trix_attachment_image(att, trix_params)
    case trix_params[:size]
    when 'completo'
      img = load_thumb(att, att.blob.metadata['width'].to_i, att.blob.metadata['height'].to_i )
    when 'custom'
      img = load_thumb(att, trix_params[:width].to_i, trix_params[:height].to_i)
    when 'thumb'
      w = Conf.find_by(gupo: 'Imagens', nome: 'thumb').value rescue 150
      h =  Conf.find_by(gupo: 'Imagens', nome: 'thumb').value rescue 150
      img = load_thumb(att, w, h)
    when 'mini'
      w = Conf.find_by(gupo: 'Imagens', nome: 'mini').value rescue 300
      h = Conf.find_by(gupo: 'Imagens', nome: 'mini').value rescue 300
      img = load_thumb(att, w, h)
    when 'medio'
      w = Conf.find_by(gupo: 'Imagens', nome: 'medio').value rescue 600
      h = Conf.find_by(gupo: 'Imagens', nome: 'medio').value rescue 600
      img = load_thumb(att, w, h)
    when 'grande'
      w = Conf.find_by(gupo: 'Imagens', nome: 'grande').value rescue 900
      h = Conf.find_by(gupo: 'Imagens', nome: 'grande').value rescue 900
      img = load_thumb(att, w, h)
    else
      img = load_thumb(att, att.blob.metadata['width'].to_i, att.blob.metadata['height'].to_i )
    end
    
    return img
  end
  
end
