# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_10_182346) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ads", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.string "nome"
    t.string "identifier"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo", default: "Componente"
    t.index ["app_id"], name: "index_ads_on_app_id"
    t.index ["identifier"], name: "index_ads_on_identifier", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "apps", force: :cascade do |t|
    t.string "site_title"
    t.string "site_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "areas", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.string "nome"
    t.string "identifier"
    t.string "device", default: "Desktop"
    t.string "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_areas_on_app_id"
    t.index ["identifier"], name: "index_areas_on_identifier", unique: true
  end

  create_table "attachment_infos", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.bigint "blob_id"
    t.boolean "public", default: true
    t.string "visible_to"
    t.string "description"
    t.string "legenda"
    t.string "keywords"
    t.string "autor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_attachment_infos_on_app_id"
  end

  create_table "aula_paginas", force: :cascade do |t|
    t.bigint "modulo_aula_id", null: false
    t.integer "indice"
    t.string "google_doc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modulo_aula_id"], name: "index_aula_paginas_on_modulo_aula_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "nome"
    t.string "identifier"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_categories_on_identifier", unique: true
    t.index ["nome"], name: "index_categories_on_nome", unique: true
  end

  create_table "categories_posts", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "post_id"], name: "index_categories_posts_on_category_id_and_post_id", unique: true
  end

  create_table "conf_grupos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_conf_grupos_on_nome", unique: true
  end

  create_table "confs", force: :cascade do |t|
    t.bigint "conf_grupo_id", null: false
    t.string "nome"
    t.string "valor"
    t.boolean "as_attachment", default: false
    t.jsonb "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conf_grupo_id", "nome"], name: "index_confs_on_conf_grupo_id_and_nome", unique: true
    t.index ["conf_grupo_id"], name: "index_confs_on_conf_grupo_id"
  end

  create_table "curso_modulos", force: :cascade do |t|
    t.bigint "curso_id", null: false
    t.string "nome"
    t.bigint "coordenador_id"
    t.integer "indice"
    t.boolean "ativo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curso_id"], name: "index_curso_modulos_on_curso_id"
  end

  create_table "cursos", force: :cascade do |t|
    t.string "nome"
    t.string "identifier"
    t.bigint "coordenador_id"
    t.integer "horas"
    t.string "tipo"
    t.boolean "ativo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_cursos_on_identifier", unique: true
  end

  create_table "evaluation_questions", force: :cascade do |t|
    t.bigint "modulo_evaluation_id", null: false
    t.integer "indice"
    t.string "tipo"
    t.integer "peso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modulo_evaluation_id"], name: "index_evaluation_questions_on_modulo_evaluation_id"
  end

  create_table "front_scripts", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.text "header_scripts"
    t.text "footer_scripts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_front_scripts_on_app_id"
  end

  create_table "front_styles", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.text "styles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_front_styles_on_app_id"
  end

  create_table "login_logs", force: :cascade do |t|
    t.bigint "user_or_adm"
    t.string "status"
    t.string "ip"
    t.string "visit_token"
    t.string "location"
    t.string "so"
    t.string "browser"
    t.string "user_agent"
    t.string "device"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.string "nome"
    t.bigint "parent_id"
    t.integer "indice"
    t.string "tipo"
    t.string "link"
    t.string "rota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.string "nome"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_menus_on_app_id"
    t.index ["identifier"], name: "index_menus_on_identifier", unique: true
  end

  create_table "modulo_aulas", force: :cascade do |t|
    t.bigint "curso_modulo_id", null: false
    t.string "nome"
    t.integer "indice"
    t.string "tipo"
    t.boolean "ativo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curso_modulo_id"], name: "index_modulo_aulas_on_curso_modulo_id"
  end

  create_table "modulo_evaluations", force: :cascade do |t|
    t.bigint "curso_modulo_id", null: false
    t.bigint "modulo_aula_id"
    t.string "tipo"
    t.integer "indice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curso_modulo_id"], name: "index_modulo_evaluations_on_curso_modulo_id"
  end

  create_table "notifies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profile_origin_id"
    t.text "message"
    t.jsonb "dados"
    t.boolean "lido", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifies_on_user_id"
  end

  create_table "pagemaker_components", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.string "pagemaker_identifier"
    t.jsonb "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_pagemaker_components_on_app_id"
  end

  create_table "pagemaker_fields", force: :cascade do |t|
    t.bigint "pagemaker_id", null: false
    t.string "label"
    t.string "field_type"
    t.string "default_value"
    t.jsonb "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pagemaker_id"], name: "index_pagemaker_fields_on_pagemaker_id"
  end

  create_table "pagemakers", force: :cascade do |t|
    t.string "component"
    t.string "identifier"
    t.string "ico"
    t.string "description"
    t.text "html_base"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "builder_info"
    t.index ["identifier"], name: "index_pagemakers_on_identifier", unique: true
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.string "nome"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "device", default: "Desktop"
    t.bigint "parent_id"
    t.bigint "header_area_id"
    t.bigint "footer_area_id"
    t.index ["app_id"], name: "index_pages_on_app_id"
    t.index ["identifier"], name: "index_pages_on_identifier", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "identifier"
    t.string "titulo"
    t.datetime "published_in"
    t.datetime "changed_in"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "autor"
    t.string "origin", default: "App"
    t.index ["identifier"], name: "index_posts_on_identifier", unique: true
    t.index ["published_in"], name: "index_posts_on_published_in"
  end

  create_table "posts_tags", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "post_id"], name: "index_posts_tags_on_tag_id_and_post_id", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "identifier"
    t.string "tipo", default: "person"
    t.string "nickname"
    t.boolean "active"
    t.text "bio"
    t.string "site"
    t.integer "picture"
    t.string "country"
    t.string "state"
    t.string "city"
    t.bigint "parent_id"
    t.string "slug"
    t.bigint "owner_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "question_alternatives", force: :cascade do |t|
    t.bigint "evaluation_question_id", null: false
    t.integer "indice"
    t.boolean "is_discursiva", default: false
    t.boolean "correta", default: false
    t.integer "min_words"
    t.integer "max_words"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_question_id"], name: "index_question_alternatives_on_evaluation_question_id"
  end

  create_table "site_pages", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.string "route", null: false
    t.string "titulo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_site_pages_on_app_id"
    t.index ["route"], name: "index_site_pages_on_route", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "nome"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "login"
    t.string "nome"
    t.string "email"
    t.date "nascimento"
    t.text "terms"
    t.boolean "terms_acpetd", default: false
    t.string "token"
    t.string "recovery_token"
    t.integer "user_level", default: 5
    t.datetime "confirmation_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ads", "apps"
  add_foreign_key "areas", "apps"
  add_foreign_key "attachment_infos", "apps"
  add_foreign_key "aula_paginas", "modulo_aulas"
  add_foreign_key "confs", "conf_grupos"
  add_foreign_key "curso_modulos", "cursos"
  add_foreign_key "evaluation_questions", "modulo_evaluations"
  add_foreign_key "front_scripts", "apps"
  add_foreign_key "front_styles", "apps"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "apps"
  add_foreign_key "modulo_aulas", "curso_modulos"
  add_foreign_key "modulo_evaluations", "curso_modulos"
  add_foreign_key "notifies", "users"
  add_foreign_key "pagemaker_components", "apps"
  add_foreign_key "pagemaker_fields", "pagemakers"
  add_foreign_key "pages", "apps"
  add_foreign_key "profiles", "users"
  add_foreign_key "question_alternatives", "evaluation_questions"
  add_foreign_key "site_pages", "apps"
end
