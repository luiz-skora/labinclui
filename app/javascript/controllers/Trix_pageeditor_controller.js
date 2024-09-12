import { Controller } from "@hotwired/stimulus"
//import Trix from 'trix'

//https://stackoverflow.com/questions/70837739/dynamicly-add-a-button-that-is-linked-to-an-action
import Rails from "@rails/ujs"

//https://dev.to/rockwell/adding-custom-attributes-to-trixs-toolbar-21pl
//https://github.com/basecamp/trix/blob/main/src/trix/config/block_attributes.coffee


export default class extends Controller {
  static get targets() {
      return [ "field" ]
  }



  connect(){
    console.log('page_editor connect')

    this.removeButtons()
    this.addButtons()
    this.eventListnerForButton()


    //Trix.config.textAttributes.columns = { tagName: "trix_columns", inheritable: true}
    // /*
    Trix.config.blockAttributes.pm_row = {
      tagName: 'pm_row',
      //parse: false,
      parser: (element) => {
        element.allowedAttributes = 'class'
      }

    }
    Trix.config.blockAttributes.pm_col = {
      tagName: 'pm_col',
      listAttribute: 'pm_row',
      group: false,
      nestable: true,
      /*
      test: function(element) {
        return Trix.tagName(element.parentNode) === Trix.config.blockAttributes[this.listAttribute].tagName
      }
      //*/
    }
    //'<pm_row class="row" data-trix-my="my-data"><pm_col class="col1">col 1</pm_col><pm_col class="col2>col 2</pm_col></pm_row>'

    //*/


    //o esquema está em adicionar atributos a tag. estude o código:

    //https://github.com/basecamp/trix/blob/main/src/trix/config/block_attributes.coffee

    //https://github.com/basecamp/trix/blob/main/src/trix/config/serialization.coffee


    /*,listAttribute: 'my-attribute',
     * test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
      */
    console.log(Trix.config.blockAttributes)
  }

  removeButtons() {
    this.toolbarElement.querySelector('[data-trix-button-group="block-tools"]').remove()
    this.toolbarElement.querySelector('[data-trix-button-group="history-tools"]').remove()
    this.toolbarElement.querySelector('[data-trix-action="attachFiles"]').remove()
  }

  addButtons(){
    const elementsButton = `<button type="button" name="componentes" class="trix-button" data-trix-attribute="set_componente" data-trix-action="show_componente" data-action="click->trix#show_componente" data-dialog="show_componentes_dialog" title="Componentes" tabindex="-1" data-current-value="componentes">Componentes</button>`

    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", elementsButton)

    const columnsButton = `<button type="button" name="columns" class="trix-button" data-trix-attribute="set_columns" data-trix-action="show_columns" data-action="click->trix#show_columns" data-dialog="show_columns_dialog" title="Colunas" tabindex="-1" data-current-value="columns">Colunas</button>`

    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", columnsButton)
  }

  eventListnerForButton() {
    this.toolbarElement.querySelector('[data-trix-action="show_componente"]').addEventListener("click", e => { this.showComponentes(e)})

    this.toolbarElement.querySelector('[data-trix-action="show_columns"]').addEventListener("click", e => { this.showColumns(e)})
  }

  showComponentes(e) {
    console.log('showComponentes')
    var dialogURL = $(this.element).data('pagemaker-url')
    var editor_id = $(this.element).data('editor-id')

    Rails.ajax({
      type: 'patch',
      url: dialogURL,
      data: 'editor_id='+editor_id,
      dataType: 'srcipt'
    })
  }

  showColumns(e) {
    console.log('showComponentes')
    var dialogURL = $(this.element).data('columns-url')
    var editor_id = $(this.element).data('editor-id')

    Rails.ajax({
      type: 'patch',
      url: dialogURL,
      data: 'editor_id='+editor_id,
      dataType: 'srcipt'
    })
  }


  //////////////// UTILS     ///////////////////////

  get buttonGroupBlockTools() {
   return this.toolbarElement.querySelector("[data-trix-button-group=block-tools]")
 }

 get buttonGroupTextTools() {
   return this.toolbarElement.querySelector("[data-trix-button-group=text-tools]")
 }

 get buttonGroupFileTools(){
   return this.toolbarElement.querySelector("[data-trix-button-group=file-tools]")
 }

 get dialogsElement() {
   return this.toolbarElement.querySelector("[data-trix-dialogs]")
 }

 get toolbarElement() {
    return this.element.toolbarElement
  }

get pieceAtCursor() {
    return this.trixEditorDocument.getPieceAtPosition(this.trixEditor.getPosition())
  }

  get trixEditor() {
    return this.element.editor
  }

  get trixEditorDocument() {
    return this.element.editor.getDocument()
  }

  get fontSizeDropdownLabelContainer() {
    return this.element.querySelector('[data-custom-dropdown-target="placeholderText"]')
  }

  get currentState() {
    return {
      boldValue: this.boldValue,
      italicValue: this.italicValue,
      alignmentValue: this.alignmentInputTarget.value,
      color: this.colorValue,
      sizeValue: this.sizeValue,
      trix: this.trix
    }
  }


}
