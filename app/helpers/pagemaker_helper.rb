module PagemakerHelper

  def initialize_pagemaker_components
    #if Pagemaker.find_by(identifier: 'html').nil?
    #  create_html
    #end
    if Pagemaker.find_by(identifier: 'logo').nil?
      create_logo
    end
    if Pagemaker.find_by(identifier: 'data').nil?
      create_data
    end
    if Pagemaker.find_by(identifier: 'anuncio').nil?
      create_anuncio
    end
    if Pagemaker.find_by(identifier: 'imagem').nil?
      create_imagem
    end
    if Pagemaker.find_by(identifier: 'menu').nil?
      create_menu
    end
    if Pagemaker.find_by(identifier: 'destaque').nil?
      create_destaque
    end
    if Pagemaker.find_by(identifier: 'eslaides-de-publicacoes').nil?
      create_eslaiders
    end
    if Pagemaker.find_by(identifier: 'publicacao').nil?
      create_post
    end
    if Pagemaker.find_by(identifier: 'categoria').nil?
      create_categoria
    end
    if Pagemaker.find_by(identifier: 'tag').nil?
      create_tag
    end
    if Pagemaker.find_by(identifier: 'youtube').nil?
      create_youtube
    end
    if Pagemaker.find_by(identifier: 'pdf').nil?
      create_pdf
    end
    if Pagemaker.find_by(identifier: 'google-doc').nil?
      create_google_docs
    end

  end

  def initialize_component_fields(fields)
    case fields[:pm_ident]
    when 'logo'
      grupo = ConfGrupo.find_by(nome: 'Aplicação')
      if grupo.present?
        app_logo = grupo.conf.find_by(nome: 'app_logo')
        if app_logo.present? && app_logo.attachment.present?
          fields[:image_width] = app_logo.attachment.metadata['width'] rescue ''
          fields[:image_height] = app_logo.attachment.metadata['height'] rescue ''
        end
      end
    end

    return fields
  end

  def create_google_docs
    mk = Pagemaker.new
    mk.component = 'Google Doc'
    mk.ico = 'pm/google.svg'
    mk.description = 'Incorpora um documento gerado no Google Docs'
    mk.builder_info = 'O documento incorporado precisa ser compartilhado com a função de leitor para qualquer pessoa com o link.'
    mk.html_base = 'pagemaker/base/gdoc'

    mk.save

    f = mk.pagemaker_field.new
    f.label = 'document_id'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'aspect_ratio'
    f.field_type = 'select'
    f.options = {'1:1' => ' 100', '4:3' => '75', '3:2' => '66.66', '8:5' => '62.5', '16:9' => '56.25', '3:4' => '133.33', '2:3' => '150', '5:8' =>'160', '9:16' => '177.77'  }
    f.default_value = '56.25'
    f.save
  end

  def create_pdf
    mk = Pagemaker.new
    mk.component = 'PDF'
    mk.ico = 'pm/file-pdf-solid'
    mk.description = 'Incorpora um documento PDF'
    mk.html_base = 'pagemaker/base/pdf'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'file_pdf'
    f.field_type = 'pdf_select'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'titulo'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'legenda'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'full_width'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'width'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'aspect_ratio'
    f.field_type = 'select'
    f.options = {'1:1' => ' 100', '4:3' => '75', '3:2' => '66.66', '8:5' => '62.5', '16:9' => '56.25', '3:4' => '133.33', '2:3' => '150', '5:8' =>'160', '9:16' => '177.77'  }
    f.default_value = '56.25'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'centro'
    f.save


  end

  def create_youtube
    mk = Pagemaker.new
    mk.component = 'YouTube'
    mk.ico = 'pm/youtube'
    mk.description = 'Incorpora um vídeo do YouTube'
    mk.html_base = 'pagemaker/base/youtube'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'video_src'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'titulo'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'legenda'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'full_width'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'width'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'aspect_ratio'
    f.field_type = 'select'
    f.options = {'1:1' => ' 100', '4:3' => '75', '3:2' => '66.66', '8:5' => '62.5', '16:9' => '56.25', '3:4' => '133.33', '2:3' => '150', '5:8' =>'160', '9:16' => '177.77'  }
    f.default_value = '56.25'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'centro'
    f.save


  end

  def create_tag
    mk = Pagemaker.new
    mk.component = 'tag'
    mk.ico = 'pm/tag.svg'
    mk.description = 'Exibe publicações de uma tag'
    mk.html_base = 'pagemaker/base/tag'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'num_posts'
    f.field_type = 'number'
    f.default_value = 20
    f.save

  end

  def create_categoria
    mk = Pagemaker.new
    mk.component = 'Categoria'
    mk.ico = 'pm/sitemap.svg'
    mk.description = 'Exibe publicações de uma categoria'
    mk.html_base = 'pagemaker/base/categoria'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'num_posts'
    f.field_type = 'number'
    f.default_value = 20
    f.save

  end

  def create_post
    mk = Pagemaker.new
    mk.component = 'Publicação'
    mk.ico = 'pm/file-alt-regular.svg'
    mk.description = 'Exibe uma publicação'
    mk.html_base = 'pagemaker/base/post'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'layout'
    f.field_type = 'select'
    f.options = {'padrão' => 'padrao'}
    f.default_value = 'padrao'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'class'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_title'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_categories'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_tags'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_datetime_publish'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_datetime_changed'
    f.field_type = 'checkbox'
    f.default_value = '0'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_author'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_resumo'
    f.field_type = 'checkbox'
    f.default_value = '0'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_imagem_destacada'
    f.field_type = 'checkbox'
    f.default_value = '0'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_content'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_share_buttons'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_read_more_button'
    f.field_type = 'checkbox'
    f.default_value = '0'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'read_more_button_paragraphs'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_related_posts'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save
  end

  def create_anuncio
    mk = Pagemaker.new
    mk.component = 'Anúncio'
    mk.ico = 'pm/store-solid.svg'
    mk.description = 'Adiciona um anúncio'
    mk.html_base = 'pagemaker/base/ads'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'ads'
    f.field_type = 'select_ads'
    f.options = 'get_ads'
    f.default_value = ''
    f.save
  end

  def create_destaque
    mk = Pagemaker.new
    mk.component = 'Destaque'
    mk.ico = 'pm/address-card-regular.svg'
    mk.description = 'Adiciona cartões de destaque para as publicações'
    mk.html_base = 'pagemaker/base/card_post'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'category'
    f.field_type = 'select_category'
    f.options = 'get_category'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'num_posts'
    f.field_type = 'number'
    f.default_value = 3
    f.save

    f = mk.pagemaker_field.new
    f.label = 'offset'
    f.field_type = 'number'
    f.default_value = 0
    f.save



    f = mk.pagemaker_field.new
    f.label = 'category_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'category_alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'class'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'disposition'
    f.field_type = 'select'
    f.options = {'bloco' => 'bloco', 'imagem-esquerda' => 'imagem_esquerda', 'imagem-direita' => 'imagem_direita'}
    f.default_value = 'bloco'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'card_height'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_font_size'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'card_image_width'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'card_image_aspect_ratio'
    f.field_type = 'select'
    f.options = {'1:1' => ' 100', '4:3' => '75', '3:2' => '66.66', '8:5' => '62.5', '16:9' => '56.25', '3:4' => '133.33', '2:3' => '150', '5:8' =>'160', '9:16' => '177.77'  }
    f.default_value = '75'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'card_image_full_width'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'card_image_padding'
    f.field_type = 'number'
    f.default_value = 8
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_text_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_text_type'
    f.field_type = 'select'
    f.options = {'conteúdo' => 'conteudo', 'resumo' => 'resumo'}
    f.default_value = 'resumo'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_text_length'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_text_alignment'
    f.field_type = 'select'
    f.options = {'justificado'=> 'justificado','esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'justificado'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_text_font_size'
    f.field_type = 'number'
    f.default_value = ''
    f.save

  end

  def create_eslaiders
    mk = Pagemaker.new
    mk.component = 'Eslaides de publicações'
    mk.ico = 'pm/images-regular.svg'
    mk.description = 'Exibe eslaides das publicações'
    mk.builder_info = ''
    mk.html_base = 'pagemaker/base/slider'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'category'
    f.field_type = 'select_category'
    f.options = 'get_category'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'class'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'num_posts'
    f.field_type = 'number'
    f.default_value = 6
    f.save

    f = mk.pagemaker_field.new
    f.label = 'slider_delay'
    f.field_type = 'number'
    f.default_value = 8
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_width'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'aspect_ratio'
    f.field_type = 'select'
    f.options = {'1:1' => ' 100', '4:3' => '75', '3:2' => '66.66', '8:5' => '62.5', '16:9' => '56.25' }
    f.default_value = '75'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_full_width'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_padding'
    f.field_type = 'number'
    f.default_value = 8
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_navigation_bar'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'navigation_bar'
    f.field_type = 'select'
    f.options = { 'pontos' => 'pontos'} #'miniaturas' => 'miniaturas',
    f.default_value = 'miniaturas'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'navigation_bar_position'
    f.field_type = 'select'
    f.options = {'abaixo interno' => 'abaixo_interno', 'abaixo externo' => 'abaixo_externo', 'acima interno' => 'acima_interno'}
    f.default_value = 'abaixo_externo'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'navigation_bar_unselected_opacity'
    f.field_type = 'number'
    f.default_value = '50'
    f.save


    f = mk.pagemaker_field.new
    f.label = 'navigation_arrows'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'show_post_title'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_font_size'
    f.field_type = 'number'
    f.default_value = nil
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_position'
    f.field_type = 'select'
    f.options = {'abaixo' => 'abaixo', 'centro' => 'centro', 'acima' => 'acima'}
    f.default_value = 'abaixo'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_full_width'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_padding'
    f.field_type = 'number'
    f.default_value = '8'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_color'
    f.field_type = 'color'
    f.default_value = '#FFFFFF'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_background_color'
    f.field_type = 'color'
    f.default_value = '#000000'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'post_title_background_opacity'
    f.field_type = 'number'
    f.default_value = '50'
    f.save

  end

  def create_menu
    mk = Pagemaker.new
    mk.component = 'Menu'
    mk.ico = 'pm/bars-solid.svg'
    mk.description = 'Adiciona um menu'
    mk.builder_info = 'Menus são definidos em Aparência -> Menus'
    mk.html_base = 'pagemaker/base/menu'

    mk.save

    f = mk.pagemaker_field.new
    f.label = 'menu'
    f.field_type = 'select_menu'
    f.options = 'get_menus'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'class'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    #f = mk.pagemaker_field.new
    #f.label = 'responsivo'
    #f.field_type = 'select'
    #f.options {'<576' => ' ', '>576' => 'sm', '>768' => 'md', '>960' => 'lg', '>=1140' => 'xl' }
    #f.default_value = ''
    #f.save

    f = mk.pagemaker_field.new
    f.label = 'orientation'
    f.field_type = 'select'
    f.options = { 'horizontal' => 'horizontal', 'vertical' => 'vertical'}
    f.default_value = 'horizontal'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label =  'embed_search_form'
    f.field_type = 'checkbox'
    f.default_value = '0'
    f.save
  end

  def create_imagem
    mk = Pagemaker.new
    mk.component = 'Imagem'
    mk.ico = 'pm/image-regular.svg'
    mk.description = 'Adiciona uma imagem'
    mk.html_base = 'pagemaker/base/image'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'image'
    f.field_type = 'image_select'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'width'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'aspect_ratio'
    f.field_type = 'select'
    f.options = {'1:1' => ' 100', '4:3' => '75', '3:2' => '66.66', '8:5' => '62.5', '16:9' => '56.25', '3:4' => '133.33', '2:3' => '150', '5:8' =>'160', '9:16' => '177.77'  }
    f.default_value = '75'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'card_image_full_width'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'label'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'link'
    f.field_type = 'string'
    f.default_value = ''
    f.save
  end

  def create_data
    mk = Pagemaker.new
    mk.component = 'Data'
    mk.ico = 'pm/calendar-day-solid.svg'
    mk.description = 'Adiciona a data atual'
    mk.html_base = 'pagemaker/base/data'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'locality'
    f.field_type = 'string'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'locality_show'
    f.field_type = 'checkbox'
    f.default_value = '0'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'format'
    f.field_type = 'select'
    f.options = {'Dia / Mês / Ano' => 'default', 'Dia de Mês' => 'short', 'Dia de Mês de Ano' => 'long', 'Dia da semana, Dia de Mês de Ano' => 'weekday_long'}
    f.default_value = 'long'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'font_size'
    f.field_type = 'number'
    f.default_value = '12'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'font_color'
    f.field_type = 'color'
    f.default_value = '#666666'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'background_color'
    f.field_type = 'color'
    f.default_value = '#ffffff'
    f.save
  end

  def create_logo
    mk = Pagemaker.new
    mk.component = 'Logo'
    mk.ico = 'pm/id-badge-regular.svg'
    mk.description = 'Adiciona o logotipo do site'
    mk.html_base = 'pagemaker/base/logo'
    mk.builder_info = 'Imagem, título e descrição são definidos em: Configurações -> Aplicação -> app_logo anexo, app_title valor e app_description valor, respctivamente.'
    mk.save

    f = mk.pagemaker_field.new
    f.label = 'disposition'
    f.field_type = 'select'
    f.options = {'bloco' => 'bloco', 'imagem-esquerda' => 'imagem_esquerda', 'imagem-direita' => 'imagem_direita'}
    f.default_value = 'bloco'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_width'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'image_height'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_font_size'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'title_font_color'
    f.field_type = 'color'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'description_show'
    f.field_type = 'checkbox'
    f.default_value = '1'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'description_alignment'
    f.field_type = 'select'
    f.options = {'esquerda' => 'esquerda', 'centro' => 'centro', 'direita' => 'direita'}
    f.default_value = 'esquerda'
    f.save

    f = mk.pagemaker_field.new
    f.label = 'description_font_size'
    f.field_type = 'number'
    f.default_value = ''
    f.save

    f = mk.pagemaker_field.new
    f.label = 'description_font_color'
    f.field_type = 'color'
    f.default_value = ''
    f.save

  end

  def create_html
    mk = Pagemaker.new
    mk.component = 'HTML'
    mk.ico = 'pm/code-solid.svg'
    mk.description = 'Adiciona texto HTML'
    mk.html_base = 'pagemaker/base/html'
    mk.save

    mk_f = mk.pagemaker_field.new
    mk_f.label = 'content'
    mk_f.field_type = 'text'
    mk_f.save
  end



end
