module ApplicationHelper

  def error_tag(model, attribute)
    if model.errors.has_key? attribute
      model.errors[attribute].first
    end
  end
  
  def error_header(model)
    if model.errors.any? 
      err_count = model.errors.count
      s = 'errors.template.header.'
      s += (err_count > 1 ? 'other' : 'one' )
      content_tag( :div, 
                   content_tag( :h3, 
                                t(s, model: t(model.model_name.name), count: err_count), class: 'error_message' ) + 
                 content_tag( :p, t('errors.template.body') ), 
              id: 'error_explanation') 
    end
  end

  def default_meta_tags(page)
    app_title = Conf.find_by(nome: 'app_title').valor rescue 'Jornal Correio do Brasil'
    app_description = Conf.find_by(nome: 'app_description').valor rescue 'Conf -> aplicação -> app_description'
    app_site = Conf.find_by(nome: 'site_url').valor rescue 'Conf -> aplicação -> site_url'
    {
      title: page.nome,
      description: app_description,
      site: app_title,
      charset: 'utf-8',
      robots: 'index,follow',
      canonical: request.original_url
    }
  end

  def home_meta_tags
    app_title = Conf.find_by(nome: 'app_title').valor rescue 'Jornal Correio do Brasil'
    app_description = Conf.find_by(nome: 'app_description').valor rescue 'Conf -> aplicação -> app_description'
    app_site = Conf.find_by(nome: 'site_url').valor rescue 'Conf -> aplicação -> site_url'
    app_image = Conf.find_by(nome: 'app_image').attachment rescue nil

    {
      title: 'Capa',
      description: app_description,
      site: app_title,
      charset: 'utf-8',
      robots: 'index,follow',
      follow: 'index',
      canonical: request.original_url,
      image_src: ( rails_blob_url(app_image) rescue '' ),
      keywords: Category.order(:id).map{|k| k.nome },
      referrer: 'always',
      index: true,
      #nofollow: true,
      og: {
        description: :description,
        image: :image_src,
        locale: 'pt_BR',
        site_name: app_title,
        title: app_title,
        type: 'website',
        url: :canonical
      },
      twitter: {
        card: 'summary',
        image: :image_src,
        creator: app_title,
        description: :description,
        site: :canonical,
        title: app_title
      }
    }
  end
  
  def post_meta_tags(post)
    app_title = Conf.find_by(nome: 'app_title').valor rescue 'Jornal Correio do Brasil'
    article_image = (post.featured_image.present? ? post.featured_image : post.attachment.first if present?) rescue nil
    {
      charset: 'utf-8',
      description: post.resumo.body.to_plain_text,
      robots: 'index,follow,max-image-preview:large',
      follow: 'index',
      title: post.titulo,
      site: app_title,
      canonical: request.original_url,
      image_src: (rails_blob_url(article_image) rescue ''),
      referrer: 'always',
      keywords: post.categories.map{|k| k.nome }.concat(post.tags.map{|h| h.nome}),
      index: true,
      #nofollow: true,
      article: {
        published_time: post.published_in,
        section: post.categories.map{|k| k.nome},
        tag: post.tags.map{|k| k.nome }
      },
      og: {
        description: :description,
        image: :image_src,
        locale: 'pt_BR',
        site_name: :site,
        title: :title,
        description: :description,
        type: 'article',
        url: :canonical
      },
      twitter: {
        card: 'summary',
        image: :image_src,
        creator: app_title,
        description: :description,
        site: :canonical,
        title: app_title
      }
    }
  end

  def category_meta_tags(category)
    app_title = Conf.find_by(nome: 'app_title').valor rescue 'Jornal Correio do Brasil'
    {
      title: "Artigos arquivados em #{category.nome}",
      description: :title,
      site: app_title,
      charset: 'utf-8',
      robots: 'index,follow',
      follow: 'index',
      canonical: request.original_url,
      image_src: ( rails_blob_url(app_image) rescue '' ),
      keywords: category.nome,
      referrer: 'always',
      index: true,
      #nofollow: true,
      og: {
        description: :description,
        image: :image_src,
        locale: 'pt_BR',
        site_name: app_title,
        title: app_title,
        type: 'page',
        url: :canonical
      },
      twitter: {
        card: 'summary',
        image: :image_src,
        creator: app_title,
        description: :description,
        site: :canonical,
        title: app_title
      }
    }
  end

  def tag_meta_tags(tag)
    app_title = Conf.find_by(nome: 'app_title').valor rescue 'Jornal Correio do Brasil'
    {
      title: "Artigos arquivados em #{tag.nome}",
      description: :title,
      site: app_title,
      charset: 'utf-8',
      robots: 'index,follow',
      follow: 'index',
      canonical: request.original_url,
      image_src: ( rails_blob_url(app_image) rescue '' ),
      keywords: tag.nome,
      referrer: 'always',
      index: true,
      #nofollow: true,
      og: {
        description: :description,
        image: :image_src,
        locale: 'pt_BR',
        site_name: app_title,
        title: app_title,
        type: 'page',
        url: :canonical
      },
      twitter: {
        card: 'summary',
        image: :image_src,
        creator: app_title,
        description: :description,
        site: :canonical,
        title: app_title
      }
    }
  end

  def page_meta_tags(page_identifier)

    app_title = Conf.find_by(nome: 'app_title').valor rescue 'Jornal Correio do Brasil'

    {
      title: page_identifier,
      description: :title,
      site: app_title,
      charset: 'utf-8',
      robots: 'index,follow',
      follow: 'index',
      canonical: request.original_url,
      image_src: ( rails_blob_url(app_image) rescue '' ),
      keywords: ppage_identifier,
      referrer: 'always',
      index: true,
      #nofollow: true,
      og: {
        description: :description,
        image: :image_src,
        locale: 'pt_BR',
        site_name: app_title,
        title: app_title,
        type: 'page',
        url: :canonical
      },
      twitter: {
        card: 'summary',
        image: :image_src,
        creator: app_title,
        description: :description,
        site: :canonical,
        title: app_title
      }
    }

  end

  def gravatar(user, size, strong=true)
    p = user.profile
    content_tag(:div, show_profile_picture(p, size), class: 'picture-frame' ) +
        (strong ? content_tag(:strong, p.nickname) : content_tag(:spam, p.nickname))
          
  end

  def show_profile_picture(profile, size)
    if profile.profile_picture.present? && profile.profile_picture.valid?
      img = profile.profile_picture
      image_tag(img.variant(resize_to_fill: [size, size] ))
      #content_tag :img, '', src:  url_for(img.variant(resize_to_fill: [size, size] )), height: size, width: size
    else      
      case profile.tipo
        when 'person'
          img = 'user.png'
        when 'grupo'
          img = 'users.png'
        else
          img = 'user.png'
      end
      image_tag(img, src: path_to_asset(img), size: size)
    end
  end
  
  def user_level_to_text(user_level)
    case(user_level)
    when 0
      'Nhamandú'
    when 1
      'Administrador'
    when 2
      'Supervisor'
    when 3
      'Editor'
    when 4
      'Assinante'
    when 5
      'Visitante'
    else
      'Indefinido'
    end
  end
  
  def user_level_for_select(s)
    options_for_select({
      'Administrador' => 1,
      'Supervisor' => 2,
      'Editor' => 3,
      'Assinante' => 4,
      'Visitante' => 5
    }, s)
  end
  
  def curso_tipo_for_select(s)
    options_for_select({
      'Presencial' => 'Presencial',
      'Remoto' => 'Remoto',
      'Híbrido' => 'Híbrido'                        
    }, s)
  end
  
  def aula_tipo_for_select(s)
    options_for_select({
      'Presencial' => 'Presencial',
      'Remoto ao vivo' => 'Remoto ao vivo',
      'Remoto autônomo' => 'Remoto autônomo',
      'Laboratório' => 'Laboratório'
    }, s)
  end
  
  def tipo_questionario_for_select(s)
    options_for_select({
      'Fixação' => 'Fixação',
      'Avaliação' => 'Avaliação'      
    }, s)
  end
  
  def question_tipo_for_select(s)
    options_for_select({
      'Múltipla Escolha' => 'Múltipla Escolha',
      'Somatória' => 'Somatória',
      'Discursiva' => 'Discursiva'
    }, s)
  end
  
  def disponibilizacao_aula_for_select(s)
    options_for_select({
      'Após ativação da turma' => 'Após ativação da turma',
      'Após conclusão do módulo anterior' => 'Após conclusão do módulo anterior',
      'Após conclusão da aula anterior' => 'Após conclusão da aula anterior',
      'Agendada' => 'Agendada'                        
    }, s )
  end
  
  def disponibilizacao_evaluation_for_select(s)
    options_for_select({
      'Após ativação da turma' => 'Após ativação da turma',
      'Após conclusão do módulo anterior' => 'Após conclusão do módulo anterior',
      'Após conclusão da aula anterior' => 'Após conclusão da aula anterior',
      'Após conclusão das aulas do Módulo' => 'Após conclusão das aulas do Módulo',
      'Agendada' => 'Agendada'                        
    }, s )
  end
  
  
  def entrega_trabalho_for_select(s)
    options_for_select({
      'A partir do inicio do curso' => 'A partir do inicio do curso',
      'Agendada' => 'Agendada'
    }, s)
  end
  
  def item_menu_tipo_for_select(s)
    options_for_select({
      'Url' => 'url',
      'Página' => 'pagina'                        
    }, s)
  end
  


end
