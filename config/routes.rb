Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  match 'adm_require_login', controller: :home, action: :adm_require_login, via: :patch

  patch :request_password_recovery, controller: :users
  get :request_password_recovery, controller: :users

  resource :users, only: [] do
    get :confirmation
    get :resset_password
  end

  match :clear_cache, controller: :home, via: :get

  resource :user_sessions, only: [:create, :new, :destroy]

  #visitante
  match 'show_component/:sgid', controller: :visitor, action: :show_component, via: [:patch, :get], as: 'show_component'

  match 'featured_image_post/:post_id', controller: :visitor, action: :featured_image_post, via: [:patch, :get], as: 'featured_image_post'

  match 'load_image_post/:post_id', controller: :visitor, action: :load_image_post, via: [:patch, :get], as: 'load_image_post'
  match 'load_image_blob/:blob_id', controller: :visitor, action: :load_image_blob, via: [:patch, :get], as: 'load_image_blob'
  match 'load_att_src', controller: :visitor, action: :load_att_src, via: [:get, :patch], as: 'load_att_src'
  match 'localizar', controller: :visitor, action: 'form_find_posts', via: [:get, :patch], as: 'visitor_find_posts'

  match 'lgpd_message_accept', controller: :visitor, action: :lgpd_message_accept, via: :patch, as: 'lgpd_message_accept'

  ## Visitante ##


  match 'admin', controller: :admin, action: :index, via: [:get, :patch]
  scope 'admin', controller: :admin do

    #cursos
    match 'adm_cursos', controller: :adm_cursos, action: :index, via: [:get, :patch], as: 'adm_cursos'
    scope 'adm_cursos', controller: :adm_cursos, as: 'adm_cursos' do
      patch :lista
      patch :new_curso
      post :create_curso
      patch :filter_lista
      patch :next_page

      scope ':curso_id' do
        patch :show_curso
        patch :edit_curso
        post :update_curso

        patch :add_modulo
        post :create_modulo

        scope ':modulo_id' do
          patch :edit_modulo
          post :update_modulo
          patch :remove_modulo
          patch :disable_modulo
          patch :enable_modulo

          patch :show_aulas
          patch :new_aula
          post :create_aula

          scope ':aula_id' do
            patch :show_aula
            patch :aula_anexos
            patch :edit_aula
            post :update_aula
            patch :remove_aula
            patch :new_pagina
            post :create_pagina

            post :add_anexo
            scope ':anexo_id' do
              patch :remove_attachment
            end
            scope ':pagina_id' do
              patch :show_pagina
              patch :edit_pagina
              post :update_pagina
              patch :remove_pagina
            end

            patch :aula_evaluation
            scope ':evaluation_id' do
              post :update_aula_evaluation
              patch :show_evaluation

              patch :new_question
              post :create_question

              scope ':question_id' do
                patch :edit_question
                post :update_question
                patch :remove_question

                patch :new_alternative
                post :create_alternative
                scope ':alternative_id' do
                  patch :edit_alternative
                  post :update_alternative
                  patch :remove_alternative
                end
              end
            end
          end

          patch :modulo_evaluation
        end

        patch :trabalhos
      end
    end

    #configurações
    match 'config', action: :configuracoes, via: [:get, :patch]
    patch :conf_grupo_new
    patch :conf_grupo_create
    scope ':conf_grupo_id' do
      patch :conf_grupo_edit
      patch :conf_grupo_update
      patch :conf_grupo_remove

      patch :conf_new
      patch :conf_create
      scope ':conf_id' do
        patch :conf_edit
        patch :conf_update
        patch :conf_remove
      end
    end
    #usuários
    match 'adm_users', controller: :adm_user, action: :list, via: [:get, :patch]
    scope 'adm_users', controller: :adm_user, as: 'adm_user' do
      patch :list
      patch :next_page
      patch :filter_lista
      patch :new_user
      patch :create_user
      scope ':user_id' do
        patch :show
        patch :modal_update_user
        patch :send_confirm_mail_user
        patch :update_user
      end
    end

    scope 'adm_my_profile/:profile_identifier', controller: :adm_my_profile, as: 'adm_my_profile' do
      get :show
      patch :show
      patch :edit
      patch :update
      patch :gallery_modal
      patch :next_page_gallery
      patch :add_attachment
      patch :change_profile_picture
    end

    #POSTS
    match 'adm_posts', controller: :post, action: :lista, via: [:get, :patch]
    scope 'adm_posts', controller: :post, as: 'adm_post' do
      patch :list
      patch :next_page
      patch :filter_lista
      #patch :new
      get :new
      post :create
      patch :filter_tags
      patch :create_tag
      scope ':post_id' do
        patch :item_actions
        patch :short_update
        patch :post_edit
        get :post_edit
        patch :post_update
        #get :post_update
        get :post_view
      end
    end

    #categorias
    match 'adm_categorias', controller: :category, action: :lista, via: [:get, :patch]
    scope 'adm_categorias', controller: :category, as: 'adm_category' do
      patch :lista
      patch :new
      patch :create
      scope ':category_id' do
        patch :edit
        patch :update
        patch :remove_category
      end
    end

    #APARÊNCIA
    match 'adm_site', controller: :adm_site, action: :main, via: [:get, :patch]
    scope 'adm_site', controller: :adm_site, as: 'adm_site' do
      patch :paginas
      patch :areas
      patch :menus
      patch :midias
      patch :anuncios
      patch :styles
      patch :scripts

      patch :elements_preview

      #páginas
      patch :pages_tree_filter
      patch :page_new
      patch :page_create

      scope ':page_id' do
        patch :page_edit
        patch :page_update
        patch :page_desktop
        patch :page_tablet
        patch :page_mobile
      end

      #Áreas
      patch :areas_tree_filter
      patch :area_new
      patch :area_create
      scope ':area_id' do
        patch :area_edit
        patch :area_update
      end

      #Menus
      patch :menus_tree_filter
      patch :menu_new
      patch :menu_create
      scope ':menu_id' do
        patch :menu_edit
        patch :menu_change
        patch :menu_update
        #Menu Itens
        patch :menu_itens_tree_filter
        patch :menu_item_new
        patch :menu_item_create
        patch :filter_pages
        scope ':menu_item_id' do
          patch :menu_item_edit
          patch :menu_item_update
          patch :menu_item_remove
        end
      end

      #Anúncios
      patch :ads_tree_filter
      patch :ads_new
      patch :ads_create
      scope ':ads_id' do
        patch :ads_edit
        patch :ads_update
      end

      #styles
      scope ':app_id' do
        patch :styles_update
      end

      #scripts
      scope ':app_id' do
        patch :scripts_update
      end
    end

    #PAGEMAKER
    match 'show_components_dialog', controller: :pagemaker, action: :show_components_dialog, via: [:patch]
    match 'show_columns_dialog', controller: :pagemaker, action: :show_columns_dialog, via: [:patch]



    #componente image
    match 'pagemaker_image', controller: :gallery, action: :pagemaker_image, via: [:patch], as: 'pagemaker_image'

    #componente PDF
    match 'pagemaker_pdf', controller: :gallery, action: :pagemaker_pdf, via: [:patch], as: 'pagemaker_pdf'

    resources :pagemaker, only: [] do
      #component
      patch :setup_component
      patch :edit_setup_component
      patch :preview_component
      patch :insert_component
      patch :update_component

      #image
      patch :select_image_field

      #file_pdf
      patch :select_file_pdf_field

      #column
      patch :change_number_columns
      patch :preview_columns
      patch :insert_columns
    end

    #backups
    match 'backups', controller: :admin, action: :backups, via: [:get, :patch], as: 'backups'

    #estatísticas
    match 'stats', controller: :admin, action: :stats, via: [:get, :patch], as: 'stats'
    scope 'stats', controller: :admin do
      patch :stats_real_time
      patch :stats_history
      get :stats_refresh
    end

  end #admin



  resources :users, only: [] do
    patch :new
    patch :create
    patch :user_confirmation
    patch :set_user_profile_picture
    patch :send_mail_password_recovery
    patch :send_confirm_mail
    get :send_confirm_mail
    patch :resset_password_update
  end


  resource :profile, only: [] do
    scope ':profile_identifier' do
      get :show, controller: :profile
      patch :all_notify
      get :all_notify

    end
  end
  resources :profile, only: [] do
    scope ':profile_identifier' do
      patch :show_modal
    end
  end

  scope 'gallery', controller: :gallery do
      patch :select_att
      patch :tiny_show_modal
      patch :tiny_next_page
      patch :tiny_filter
      patch :tiny_new_att
      patch :tiny_insert_att
  end


  match 'load_att/:sgid', controller: :gallery, action: :load_att, via: [:get, :patch]


  match ':identifier', controller: :visitor, action: :by_identifier, via: [:patch, :get], as: 'by_identifier'

  ### visitante ##


  ##### ANEXOS #####
  #attachments na página da aula
  patch 'aula/blob/preview', controller: :attachments, action: :aula_att_preview, as: 'aula_att_preview'
  patch 'aula/embed/preview', controller: :attachments, action: :aula_embed_preview, as: 'aula_embed_preview'
  patch 'aula/google_docs/preview', controller: :attachments, action: :google_docs_preview, as: 'google_docs_preview'
  patch 'aula/pdf/upload', controller: :attachments, action: :pdf_upload, as: 'aula_pdf_upload'

  #html no editor trix do lauout_section
  patch 'layout_section/html_edit', controller: :attachments, action: :html_edit, as: 'sections_html_edit'
  patch 'layout_section/html_preview', controller: :attachments, action: :html_preview, as: 'sections_html_preview'

  #exibição de PDF
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'

  get 'show_pdf/:pdf_blob_id', controller: :gallery, action: :show_pdf, as: 'show_pdf'

  #google_docs
  get 'google_doc/view/:id', controller: :attachments, action: :google_doc_view, as: 'google_doc_view'

  #####   #####

  #Visitante
  match ':base/:identifier', controller: :visitor, action: :visitor_navigation, via: [:patch, :get], as: 'visitor_navigation'

end
