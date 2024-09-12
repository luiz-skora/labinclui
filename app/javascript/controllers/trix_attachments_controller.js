import { Controller } from "@hotwired/stimulus"
import Trix from 'trix'

//https://stackoverflow.com/questions/70837739/dynamicly-add-a-button-that-is-linked-to-an-action
import Rails from "@rails/ujs"


export default class extends Controller {
  static get targets() {
      return [ "field" ]
  }

  connect() {
    this.addEmbedButton()
    this.addEmbedDialog()
    this.eventListenerForEmbedButton()
    this.eventListenerForAddEmbedButton()
    this.disableLinks()
  }

  disableLinks(){
    console.log($(this), this)
    $('trix-editor[data-controller="attachments"]').find('a').click(function(){return false})
    
  }
  
  addEmbedButton() {
    /* ATTACHMENTS */
    const attButtonHTML = '<button type="button" class="trix-button trix-embed" data-trix-attribute="attachment" data-trix-action="attachment" data-action="click->tricks#attachment" title="Embutir Imagem" style="font-size: 1em;" tabindex="-1"><i class="fa-solid fa-camera-retro"></i></button>'
    
    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", attButtonHTML)
    
    /* YOUTUBE */
    const ytButtonHTML = '<button  type="button" class="trix-button tricks-embed"  data-trix-attribute="embed" data-trix-action="embed"   data-action="click->tricks#showembed" title="Embutir YouTube" style="font-size: 1em;" tabindex="-1"><i class="fa-brands fa-youtube"></i></button>'
    //this.buttonGroupBlockTools.insertAdjacentHTML("beforeend", buttonHTML)
    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", ytButtonHTML)
    /***********************************/
    
    /* GOOGLE DOCS */
    const gdButtonHTML = '<button  type="button" class="trix-button tricks-embed"  data-trix-attribute="gd_embed" data-trix-action="gd_embed"   data-action="click->tricks#showembed" title="Embutir Google Doc" style="font-size: 1em;" tabindex="-1"><i class="fa-regular fa-file-lines"></i></button>'
    //this.buttonGroupBlockTools.insertAdjacentHTML("beforeend", buttonHTML)
    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", gdButtonHTML)
    
    /***********************************/
    
    /* PDF FILES */
    const pdfButtonHTML = '<button  type="button" class="trix-button tricks-embed"  data-trix-attribute="pdf_embed" data-trix-action="pdf_embed"   data-action="click->tricks#showembed" title="Embutir PDF" style="font-size: 1em;" tabindex="-1"><i class="fa-regular fa-file-pdf"></i></button>'
    //this.buttonGroupBlockTools.insertAdjacentHTML("beforeend", buttonHTML)
    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", pdfButtonHTML)
    /***********************************/
    
    /* MENUS */
    const ButtonMenu = '<button type="button" class="trix-button trix-embed" data-trix-attribute="menu" data-trix-action="menu" data-action="click->menu" title="Adicionar Menu" style="font-size: 1em;" tabindex="-1"><i class="fa-solid fa-grip-lines"></i></button>'
    
    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", ButtonMenu)
    /**************************/
    
    /* EMBED HTML */
    const embedHTMLButtonHTML = '<button  type="button" class="trix-button tricks-embed"  data-trix-attribute="html_embed" data-trix-action="html_embed"   data-action="click->tricks#showembed" title="Embutir HTML" style="font-size: 1em;" tabindex="-1"><i class="fa-solid fa-code"></i></button>'
    this.buttonGroupFileTools.insertAdjacentHTML("beforeend", embedHTMLButtonHTML)
    /*******************************/
    
  }

  addEmbedDialog() {
    /* YOUTUBE */
    const ytDialogHTML = `<div class="trix-dialog trix-dialog--link" data-trix-dialog="embed" data-trix-dialog-attribute="embed" data-tricks-target="embeddialog">
                          <div class="trix-dialog__link-fields">
                            <input type="text" name="embed" class="trix-input trix-input--dialog" placeholder="URL do vídeo" aria-label="embed code" required="" data-trix-input="" disabled="disabled">
                            <div class="trix-button-group">
                              <input type="button" class="trix-button trix-button--dialog" data-trix-custom="add-embed" value="Add">
                            </div>
                          </div>
                        </div>`
    this.dialogsElement.insertAdjacentHTML("beforeend", ytDialogHTML)
    
    /* GOOGLE DOCS */
    const gdDialogHTML = `<div class="trix-dialog trix-dialog--link" data-trix-dialog="gd_embed" data-trix-dialog-attribute="gd_embed" data-tricks-target="embeddialog">
                          <div class="trix-dialog__link-fields">
                            <input type="text" name="gd_embed" class="trix-input trix-input--dialog" placeholder="ID do documento" aria-label="embed code" required="" data-trix-input="" disabled="disabled">
                            <div class="trix-button-group">
                              <input type="button" class="trix-button trix-button--dialog" data-trix-custom="add-gdembed" value="Add" id="add-gdembed">
                            </div>
                          </div>
                        </div>`
    this.dialogsElement.insertAdjacentHTML("beforeend", gdDialogHTML)
    
    /* PDF FILE */
    const pdfFile = `<input type="file" id="pdf-file"  accept="application/pdf" style="display: none" data-trix-custom="addPDFFile">`
    this.dialogsElement.insertAdjacentHTML("beforeend", pdfFile)
    
    /* EMBED HTML */
    ///*
    
    const embedHtmlDialogHTML = `<div class="trix-dialog" data-trix-dialog="HTMLembed" data-trix-dialog-attribute="embed" data-tricks-target="embeddialog"> 
      <div class="trix-dialog__link-fields">
        <textarea name="HTMLembed" class="trix-textarea trix-textarea--dialog" placeholder="Código HTML" aria-label="embed code" required="" data-trix-textarea="" disabled="disabled" style="font-size: 12px;"></textarea>
        <input type="hidden" name="HTMLembed_id" class="trix-input trix-input--dialog" />
        <input type="hidden" name="HTMLembed_sgid" class="trix-input trix-input--dialog" />
        <div class="trix-button-group">
          <input type="button" class="trix-button trix-button--dialog" data-trix-custom="html_embed" value="Add">
        </div>
      </div>
    </div> `
    this.dialogsElement.insertAdjacentHTML("beforeend", embedHtmlDialogHTML)
    //*/
  }


  /* ATTACHMENT */
  attachment(e) {
    console.log('attachment', this, $(this.element).data('app-editor-id'))
    Rails.ajax({
      type: 'PATCH',
      url: '/app/gallerie_show_modal.js',
      data: 'editor_id='+ $(this.element).data('app-editor-id')
    })
  }
  /* YOUTUBE */
  showembed(e){
    //console.log('showembed')
    const dialog = this.toolbarElement.querySelector('[data-trix-dialog="embed"]')
    const ytEmbedInput = this.dialogsElement.querySelector('[name="embed"]')
    if (event.target.classList.contains("trix-active")) {
      event.target.classList.remove("trix-active");
      dialog.classList.remove("trix-active");
      delete dialog.dataset.trixActive;
      ytEmbedInput.setAttribute("disabled", "disabled");
    } else {
      event.target.classList.add("trix-active");
      dialog.classList.add("trix-active");
      dialog.dataset.trixActive = "";
      ytEmbedInput.removeAttribute("disabled");
      ytEmbedInput.focus();
    }
  }
  /* GOOGLE DOCS */
  gdshowembed() {
    //console.log('gdshowembed')
    const dialog = this.toolbarElement.querySelector('[data-trix-dialog="gd_embed"]')
    const gdEmbedInput = this.dialogsElement.querySelector('[name="gd_embed"]')
    if (event.target.classList.contains("trix-active")) {
      event.target.classList.remove("trix-active");
      dialog.classList.remove("trix-active");
      delete dialog.dataset.trixActive;
      gdEmbedInput.setAttribute("disabled", "disabled");
    } else {
      event.target.classList.add("trix-active");
      dialog.classList.add("trix-active");
      dialog.dataset.trixActive = "";
      gdEmbedInput.removeAttribute("disabled");
      gdEmbedInput.focus();
    }
  }
  
  /* PDF FILES */  
  pdfAddfile(e) {
    //console.log('pdfAddfile')
    this.dialogsElement.querySelector('[data-trix-custom="addPDFFile"]').click()
  }
  
  /* MENU */
  embedMenu(e){
    var element = this.context.scope.data.scope.element
    var  v = element.querySelector('[data-trix-mutable="true"].attachment')
    var sgid = ''
    if ( $(v).length === 1 && $(v).find('.trix-menu').length === 1) {
      sgid = $(v).data('trix-attachment').sgid
    }
    
    console.log('embedMenu', this, $(this.element).data('app-editor-id'))
    Rails.ajax({
      type: 'PATCH',
      url: '/app/embed_menu_dialog.js',
      data: 'editor_id='+ $(this.element).data('app-editor-id')+'&sgid='+sgid
    })
  }
  
  /* EMBED HTML */
  htmlEmbed(e){
    
    var element = this.context.scope.data.scope.element
    
    var  v = element.querySelector('[data-trix-mutable="true"].attachment')
    
    this.dialogsElement.querySelector('[name="HTMLembed"]').value = ''
    this.dialogsElement.querySelector('[name="HTMLembed_id"]').value = ''
    this.dialogsElement.querySelector('[name="HTMLembed_sgid"]').value = ''
    
    if ( $(v).length === 1 && $(v).find('.html-preview').length === 1) {
      //console.log(this, $(v))
      this.dialogsElement.querySelector('[name="HTMLembed"]').value = $(v).find('.html-preview').html().trim()
      this.dialogsElement.querySelector('[name="HTMLembed_id"]').value = $(v).data('trix-id')
      this.dialogsElement.querySelector('[name="HTMLembed_sgid"]').value = $(v).data('trix-attachment').sgid
    }
    
    const dialog =
    this.toolbarElement.querySelector('[data-trix-dialog="HTMLembed"]')
    const htmlEmbedInput = this.dialogsElement.querySelector('[name="HTMLembed"]')
    if (event.target.classList.contains("trix-active")) {
      event.target.classList.remove("trix-active");
      dialog.classList.remove("trix-active");
      delete dialog.dataset.trixActive;
      htmlEmbedInput.setAttribute("disabled", "disabled");
    } else {
      event.target.classList.add("trix-active");
      dialog.classList.add("trix-active");
      dialog.dataset.trixActive = "";
      htmlEmbedInput.removeAttribute("disabled");
      htmlEmbedInput.focus();
    }

  }
  
  eventListenerForEmbedButton() {
    /* ATTACHMENTS */
    this.toolbarElement.querySelector('[data-trix-action="attachment"]').addEventListener("click", e => { this.attachment(e)})
    /* YOUTUBE */
    this.toolbarElement.querySelector('[data-trix-action="embed"]').addEventListener("click", e => {
      this.showembed(e)
    })
    /* GOOGLE DOCS */
    this.toolbarElement.querySelector('[data-trix-action="gd_embed"]').addEventListener("click", e => {
      //console.log('gd_embed')
      this.gdshowembed(e)
    })
    /* PDF FILES */    
    this.toolbarElement.querySelector('[data-trix-action="pdf_embed"]').addEventListener("click", e => {
      //console.log('add_pdf_embed')
      this.pdfAddfile(e)
    })
    /* MENUS */
    this.toolbarElement.querySelector('[data-trix-action="menu"]').addEventListener("click", e => { this.embedMenu(e) })
    /* EMBED HTML */
    this.toolbarElement.querySelector('[data-trix-action="html_embed"').addEventListener("click", e => {
      this.htmlEmbed(e)
    })    
  }
  
  
 
  eventListenerForAddEmbedButton() {
     /* YOUTUBE */
    this.dialogsElement.querySelector('[data-trix-custom="add-embed"]').addEventListener("click", event => {
      //console.log('embeddy')
      const content = this.dialogsElement.querySelector("[name='embed']").value
      //console.log(content)
      
      if (content && (content.search('https://www.youtube.com/watch') == 0 || content.search('https://youtu.be') == 0 )) {
        let _this = this
        let formData = new FormData()
        //console.log(content)
        formData.append("content", content)
        Rails.ajax({
          type: 'PATCH',
          url: '/aula/embed/preview.json',
          data: formData,
          success: ({content, sgid, url, blob}) => {
            //console.log(content, sgid, blob)
            const attachment = new Trix.Attachment({content, sgid, url, blob})
            _this.element.editor.insertAttachment(attachment)
            _this.element.editor.insertLineBreak()
          }
        })
      } else {
        alert('Apenas vídeos do Youtube são aceitos.')
      }
    })
    /* GOOGLE DOCS */
    this.dialogsElement.querySelector('[data-trix-custom="add-gdembed"]').addEventListener("click", event => {
      //console.log('gdEmbeddy')
      const content = this.dialogsElement.querySelector("[name='gd_embed']").value
      //console.log(content)
      
      if (content) {
        let _this = this
        let formData = new FormData()
        //console.log(content)
        formData.append("content", content)
        Rails.ajax({
          type: 'PATCH',
          url: '/aula/google_docs/preview.json',
          data: formData,
          success: ({content, sgid, url, blob}) => {
            //console.log(content, sgid, blob)
            const attachment = new Trix.Attachment({content, sgid, url, blob})
            _this.element.editor.insertAttachment(attachment)
            _this.element.editor.insertLineBreak()
          },
          error: function(){
            alert('Não foi possivel carregar o arquivo.')
          }
        })
      } 
    })
    /* PDF FILE */
    this.dialogsElement.querySelector('[data-trix-custom="addPDFFile"]').addEventListener("change", event => {
      const content = this.dialogsElement.querySelector('[data-trix-custom="addPDFFile"]').files
      //console.log('pdffile change', event, content)
      //console.log(content[0])
      
      var valid = this.validaFile(content[0])
      
      if( valid ) {
        let _this = this
        let formData = new FormData()
        formData.append("content", content[0])
        Rails.ajax({
          type: 'patch',
          url: '/aula/pdf/upload.json',
          data: formData, 
          success: ({content, sgid, url, blob}) => {
            const attachment = new Trix.Attachment({content, sgid, url, blob})
            _this.element.editor.insertAttachment(attachment)
            _this.element.editor.insertLineBreak()
          },
          error: function(){
            alert('Não foi possivel enviar o arquivo.')
          }
        })
      }
    })
    
    /* HTML EMBED */
    // /*
    this.dialogsElement.querySelector('[data-trix-custom="html_embed"]').addEventListener("click", event => {
      console.log('html_embed')
      const content = this.dialogsElement.querySelector("[name='HTMLembed']").value
      const id = this.dialogsElement.querySelector("[name='HTMLembed_id']").value 
      const sgid = this.dialogsElement.querySelector("[name='HTMLembed_sgid']").value
      console.log(content)
      
      if ( content ) {
        let _this = this
        let formData = new FormData()
        
        formData.append("content", content)
        formData.append("id", id)
        formData.append("sgid", sgid)
        Rails.ajax({
          type: 'PATCH',
          url: '/layout_section/html_preview.json',
          data: formData,
          success: ({ content, sgid }) => {
            const attachment = new Trix.Attachment({content, sgid })
            _this.element.editor.insertAttachment(attachment)
            _this.element.editor.insertLineBreak()
            
          }
        })
      }
      
    })
    
    //*/
  }
  
  validaFile(f) {
    const acceptedTypes = [ 'application/pdf' ]
    const maxSize = 15 * 1024 * 1024 //15MB
    var msg = ''
    var status = true
    //console.log(f)
    
    if( !acceptedTypes.includes(f.type) ) {
      msg = 'Formato de arquivo inválido.\nEscolha um arquivo PDF.'
      status = false
    }
    if (f.size > maxSize) {
      msg = 'Excede o tamanho máximo permitido ( 15MB ).'
      status = false
    }
    
    if( msg.length > 0 ) {
      alert(msg)
    }
    
    return status
  }

  
  
  //////////////// UTILS ////////////////////////////////////////////////////

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
}



/*   original do site com erro *
//addHeadingAttributes()
export default class extends Controller {
 
  
 static get targets() { }

 connect() {
  
  Trix.config.blockAttributes.embed = {
    
  } 
   
  this.addEmbedButton()
  this.addEmbedDialog()
  this.eventListenerForEmbedButton()
 }  

 addEmbedButton() {
  const buttonHTML = 'Embed'
  this.buttonGroupFileTools.insertAdjacentHTML("beforeend", buttonHTML)
 }

 addEmbedDialog() {
  const dialogHTML = ``
  this.dialogsElement.insertAdjacentHTML("beforeend", dialogHTML)
 }

 showembed(e){
  const dialog = this.toolbarElement.querySelector('[data-trix-dialog="embed"]')
  const embedInput = this.dialogsElement.querySelector('[name="embed"]')
  if (event.target.classList.contains("trix-active")) {
    event.target.classList.remove("trix-active");
    dialog.classList.remove("trix-active");
    delete dialog.dataset.trixActive;
    embedInput.setAttribute("disabled", "disabled");
  } else {
    event.target.classList.add("trix-active");
    dialog.classList.add("trix-active");
    dialog.dataset.trixActive = "";
    embedInput.removeAttribute("disabled");
    embedInput.focus();
  }
 }

 eventListenerForEmbedButton() {
  this.toolbarElement.querySelector('[data-trix-action="embed"]').addEventListener("click", e => {
    this.showembed(e)
  })
 }
 insertAttachment(content, sgid){
    const attachment = new Trix.Attachment({content, sgid})
    this.element.editor.insertAttachment(attachment)    
  }
} 
*/
