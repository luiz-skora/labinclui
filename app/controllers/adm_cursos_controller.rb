class AdmCursosController < ApplicationController

  layout "admin"

  PERPAGE = 20

  before_action :can_access
  before_action :clear_msg

  after_action :track_action

  def index
    lista
  end

  def lista
    @page = 0
    @query = ''
    @cursos = get_cursos(@page, @query)

    respond_to do |format|
      format.html { render 'adm_cursos' }
      format.js { render 'adm_cursos' }
    end
  end

  def next_page
    @page = params[:page].to_i
    @query = params[:query]

    @cursos = get_cursos(@page, @query)

    html = render_to_string(partial: 'lista_cursos')

    render json: { html: html, more: @more, query: @query, page: @page + 1 }
  end

  def filter_lista
    @page = 0
    @query = params[:query]
    @cursos = get_cursos(@page, @query)

    render 'filter_lista'
  end

  def new_curso
    @curso = Curso.new

    render 'new_curso'
  end

  def create_curso
    @curso = Curso.new(curso_params)

    if @curso.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("curso-data", partial: 'curso_modulos')}
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("curso-data", partial: 'new_curso')}
      end
    end
  end

  def show_curso
    @curso = Curso.find(params[:curso_id])
    @modulos = @curso.curso_modulo.order(:indice, :nome)
    render 'show_curso'
  end

  def edit_curso
    @curso = Curso.find(params[:curso_id])

    flash["msg_#{@curso.id}"] = ''

    render 'edit_curso'
  end

  def update_curso
    @curso = Curso.find(params[:curso_id])

    if @curso.update(curso_params)
      flash["msg_#{@curso.id}"] = 'Registro gravado.'
    else
      flash["msg_#{@curso.id}"] = ''
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream:  turbo_stream.replace("form_edit_curso", partial: 'edit_curso')}
    end
  end

  def add_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.new

    render 'add_modulo'
  end

  def create_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.new(modulo_params)

    if @modulo.save
      @modulos = @curso.curso_modulo.order(:indice, :nome)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('lista_modulos', partial: 'lista_modulos'),
            turbo_stream.update('modulo_edit', partial: 'edit_modulo')
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('modulo_edit', partial: 'new_modulo')}
      end
    end
  end

  def edit_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    flash[:msg] = ''
    render 'edit_modulo'
  end

  def update_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    if @modulo.update(modulo_params)
      flash[:msg] = 'Módulo gravado.'
      @modulos = @curso.curso_modulo.order(:indice, :nome)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('lista_modulos', partial: 'lista_modulos'),
            turbo_stream.update('modulo_edit', partial: 'edit_modulo')
          ]
        end
      end
    else
      flash[:msg] = ''
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('modulo_edit', partial: 'edit_modulo')}
      end
    end
  end

  def remove_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    if @modulo.modulo_aula.count == 0 && @modulo.modulo_evaluation.count == 0
      ahoy.track "admCursos módulo: #{@modulo.id} #{@modulo.nome} removido por user: #{current_user.id}", request.path_parameters
      @modulo.destroy
      @modulos = @curso.curso_modulo.order(:indice, :nome)
      render 'modulo_destroyed'
    else
      render 'modulo_not_destroyed'
    end

  end

  def disable_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @modulo.update(ativo: false)

    render 'disable_modulo'
  end

  def enable_modulo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @modulo.update(ativo: true)


    render 'enable_modulo'
  end

  def show_aulas
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aulas = @modulo.modulo_aula.order(:indice, :id)

    render 'show_aulas'
  end

  def new_aula
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    indice = @modulo.modulo_aula.count
    @aula = @modulo.modulo_aula.build(nome: "Aula ##{indice + 1}", indice: indice + 1)

    render 'new_aula'
  end

  def create_aula
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])


    @aula = @modulo.modulo_aula.new(aula_params)

    if @aula.save
      @modulos = @curso.curso_modulo.order(:indice, :nome)
      @aulas = @modulo.modulo_aula.order(:indice, :id)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('lista_modulos', partial: 'lista_modulos', locals: { selected_modulo: @modulo.id, selected_aula: @aula.id}),
            turbo_stream.update('modulo-tab-area', partial: 'show_aula')
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('modulo-tab-area', partial: 'new_aula')}
      end
    end
  end

  def show_aula
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    @paginas = @aula.aula_pagina.order(:indice, :id)

    if @paginas.count == 0
      @pagina = @aula.aula_pagina.build(indice: 1)
      render 'new_pagina'
    else
      @pagina = @aula.aula_pagina.first
      render 'show_pagina'
    end
  end

  def edit_aula
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    flash[:msg] = ''

    render 'edit_aula'
  end

  def update_aula
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    if @aula.update(aula_params)
      flash[:msg] = 'Aula gravada.'
      @modulos = @curso.curso_modulo.order(:indice, :nome)
      @aulas = @modulo.modulo_aula.order(:indice, :id)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('lista_modulos', partial: 'lista_modulos', locals: { selected_modulo: @modulo.id, selected_aula: @aula.id}),
            turbo_stream.update('adm-aula', partial: 'edit_aula')
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('adm-aula', partial: 'edit_aula')}
      end
    end
  end

  def aula_anexos
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    @anexo = @aula

    @anexos = @aula.attachments
  end

  def add_anexo
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    @anexo = @aula

    if  @anexo.attachments.attach(params[:modulo_aula][:attachments])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('aula_add_anexo', partial: 'add_anexo'),
            turbo_stream.update('aula_anexos_gallery', partial: 'aula_anexos_gallery')
          ]
        end
      end
    else
      #remove o registro e o arquivo caso o upload tenha sido efetuado
      blob = ActiveStorage::Blob.find_signed!(params[:modulo_aula][:attachments])
      if blob.present?
        blob.purge
      end
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('aula_add_anexo', partial: 'add_anexo') }
      end
    end

  end

  def remove_attachment
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    att = @aula.attachments.find(params[:anexo_id])

    att.purge

    render 'update_list_attachments'
  end

  def new_pagina
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])
    @paginas = @aula.aula_pagina.order(:indice)
    @pagina = @aula.aula_pagina.build(indice: @paginas.count + 1)

    render 'new_pagina'
  end

  def create_pagina
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])
    @pagina = @aula.aula_pagina.new(pagina_params)

    if @pagina.save
      @paginas = @aula.aula_pagina.order(:indice)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('adm-aula', partial: 'show_pagina'),
            turbo_stream.update('adm-aula-menu', partial: 'menu_adm_aula')
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('adm-aula', partial: 'new_pagina')}
      end
    end
  end

  def show_pagina
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])
    @pagina = @aula.aula_pagina.find(params[:pagina_id])
    @paginas = @aula.aula_pagina.order(:indice)
    render 'show_pagina'
  end

  def edit_pagina
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])
    @pagina = @aula.aula_pagina.find(params[:pagina_id])
    @paginas = @aula.aula_pagina.order(:indice)

    flash[:message] = ''

    render 'edit_pagina'

  end

  def update_pagina
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    @pagina = @aula.aula_pagina.find(params[:pagina_id])

    if @pagina.update(pagina_params)
      @paginas = @aula.aula_pagina.order(:indice)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('adm-aula', partial: 'show_pagina'),
            turbo_stream.update('adm-aula-menu', partial: 'menu_adm_aula')
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('adm-aula', partial: 'edit_pagina')}
      end
    end
  end

  def remove_pagina
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    @pagina = @aula.aula_pagina.find(params[:pagina_id])

    @pagina.destroy

    @paginas = @aula.aula_pagina.order(:indice, :id)

    if @paginas.count == 0
      @pagina = @aula.aula_pagina.build(indice: 1)
      render 'new_pagina'
    else
      @pagina = @aula.aula_pagina.first
      render 'show_pagina'
    end
  end

  def aula_evaluation
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])
    @aula = @modulo.modulo_aula.find(params[:aula_id])

    @evaluation = ModuloEvaluation.find_or_create_by(curso_modulo_id: @modulo.id, modulo_aula_id: @aula.id, indice: 0)

    if @evaluation.tipo.blank?
      @evaluation.update(tipo: 'Fixação')
    end

    @questions = @evaluation.evaluation_question.order(:indice, :id)

    render 'edit_avaliacao'
  end

  def update_aula_evaluation
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find_by(curso_modulo_id: @modulo.id, modulo_aula_id: (@aula.present? ? @aula.id : -1 ))

    respond_to do |format|
      if @evaluation.update(evaluation_tipo_params)
        format.turbo_stream { render turbo_stream: turbo_stream.update("evaluation-#{@evaluation.id}-tipo", html: 'Tipo alterado.')}
      else
        format.turbo_stream { render turbo_stream: turbo_stream.update("evaluation-#{@evaluation.id}-tipo", html: 'Não foi possivel alterar o tipo.')}
      end
    end
  end

  def new_question
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @indice = @evaluation.evaluation_question.count

    @question = @evaluation.evaluation_question.new(indice: @indice + 1, tipo: 'Multipla escolha', peso: 1)

    render 'aula_new_question'
  end

  def create_question
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.new(question_params)

    if @question.save
      @questions = @evaluation.evaluation_question.order(:indice, :id)
      respond_to do |format|
       format.turbo_stream { render turbo_stream:             turbo_stream.update('edit-questionario', partial: 'edit_avaliacao') }
      end
    else
      @indice = @evaluation.evaluation_question.count
      respond_to do |format|
        format.turbo_stream { render turbo_stream:             turbo_stream.replace('frm-new-question', partial: 'new_question') }
      end
    end
  end

  def edit_question
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])
    @indice = @evaluation.evaluation_question.count

    @alternatives = @question.question_alternative.order(:indice, :id)

    render 'modal_edit_question'
  end

  def update_question
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])
    @indice = @evaluation.evaluation_question.count

    @alternatives = @question.question_alternative.order(:indice, :id)

    if @question.update(question_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('modal-window', partial: 'shared/modal'),
            turbo_stream.replace("show-question-#{@question.id}", partial: 'show_question')
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('frm-edit-question', partial: 'edit_question')}
      end
    end

  end

  def remove_question
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])

    @question.destroy

    @evaluation.reindex_questions

    @questions = @evaluation.evaluation_question.order(:indice, :id)

    render 'refresh_avaliacao'
  end

  def new_alternative
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])

    @indice = @question.question_alternative.count

    @alternative = @question.question_alternative.build(indice: @indice + 1)

    if @question.tipo == 'Discursiva' && @question.question_alternative.where(is_discursiva: true).first.present?
      @alternative =  @question.question_alternative.where(is_discursiva: true).first

      render 'modal_edit_alternative'
    else
      @alternative = @question.question_alternative.build(indice: @indice + 1)
      render 'new_alternative'
    end
  end

  def create_alternative
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])

    @alternative = @question.question_alternative.new(question_alternative_params)

    if @alternative.save
      @alternatives = @question.question_alternative.order(:indice, :id)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("form-new-alternative-#{@question.id}", html: ''),
            turbo_stream.update("show-alternativas-#{@question.id}", partial: 'show_alternatives', locals: { k: @question})
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("question-#{@question.id}-form-new-alternativa", partial: 'new_alternative')}
      end
    end

  end

  def edit_alternative
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])

    @alternative = @question.question_alternative.find(params[:alternative_id])

    render 'modal_edit_alternative'
  end

  def update_alternative
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])

    @alternative = @question.question_alternative.find(params[:alternative_id])

    if @alternative.update(question_alternative_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('modal-window', partial: 'shared/modal'),
            turbo_stream.update("show-alternativas-#{@question.id}", partial: 'show_alternatives', locals: { k: @question })
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("form-edit-alternative-#{@alternative.id}", partial: 'edit_alternative')}
      end
    end
  end

  def remove_alternative
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])

    @aula = (params[:aula_id].to_i > 0 ?  @modulo.modulo_aula.find(params[:aula_id]) : nil)

    @evaluation = @modulo.modulo_evaluation.find(params[:evaluation_id])

    @question = @evaluation.evaluation_question.find(params[:question_id])

    @alternative = @question.question_alternative.find(params[:alternative_id])

    @alternative.destroy

    @question.reindex_alternatives

    render 'show_alternatives'
  end

  def modulo_evaluation
    @curso = Curso.find(params[:curso_id])
    @modulo = @curso.curso_modulo.find(params[:modulo_id])



    @evaluation = ModuloEvaluation.find_or_create_by(curso_modulo_id: @modulo.id, modulo_aula_id: -1, indice: 0)

    #@aula = @evaluation.modulo_aula_id

    if @evaluation.tipo.blank?
      @evaluation.update(tipo: 'Avaliação')
    end

    @questions = @evaluation.evaluation_question.order(:indice, :id)

    render 'modulo_evaluation'
  end

  def trabalhos

  end

  private

  def curso_params
    params.require(:curso).permit(:nome, :coordenador_id, :horas, :tipo, :content)
  end

  def modulo_params
    params.require(:curso_modulo).permit(:nome, :coordenador_id, :indice, :ativo, :content)
  end

  def aula_params
    params.require(:modulo_aula).permit(:nome, :indice, :tipo, :ativo, :content)
  end

  def pagina_params
    params.require(:aula_pagina).permit(:indice, :content)
  end

  def evaluation_tipo_params
    params.require(:modulo_evaluation).permit(:tipo)
  end

  def question_params
    params.require(:evaluation_question).permit(:indice, :tipo, :peso, :enunciado)
  end

  def question_alternative_params
      params.require(:question_alternative).permit(:indice, :is_discursiva, :correta, :min_words, :max_words, :alternative)
  end

  def get_cursos(page, filtro)
    if filtro.blank?
      lista = Curso.order(:nome).offset(PERPAGE * page).limit(PERPAGE)
      @count = Curso.all.count
    else
      sql = []
      if filtro.present?
        sql << "(nome ILIKE '%#{filtro}%' OR identifier ILIKE '%#{filtro}%' )"
      end

      query = sql.join(' AND ')
      lista = Curso.where(query).order(:nome).offset(PERPAGE * page).limit(PERPAGE)
      @count = Curso.where(query).count
    end

    @more = ( @count > (PERPAGE * (page + 1)) ? 1 : 0 )

    return lista
  end

  def can_access
    unless user_signed_in? && current_user.user_level <= 2
      redirect_to admin_path
    end
  end

  def clear_msg
    flash[:msg] = ''
  end

  def track_action
    ahoy.track "AdmCursos action", request.path_parameters
  end

end
