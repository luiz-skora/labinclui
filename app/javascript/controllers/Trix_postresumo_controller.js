import { Controller } from "@hotwired/stimulus"
import Trix from 'trix'

//https://stackoverflow.com/questions/70837739/dynamicly-add-a-button-that-is-linked-to-an-action
import Rails from "@rails/ujs"


export default class extends Controller {
  static get targets() {
      return [ "field" ]
  }

  connect() {
    console.log('post_resumo')
    this.toolbarElement.remove()
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

