import { Controller } from "@hotwired/stimulus"

import Rails from "@rails/ujs"

export default class extends Controller {
  static values = { url: String, title: String, body: String, share: String, button: String, device: String}
  static targets = ['result', 'title', 'body']

  connect() {
    if ( $(this.element).hasClass('api-share-button') && !navigator.share) {
      $(this.element).hide()
    }
    if (this.deviceValue == 'Mobile') {
      if ($(this.element).hasClass('ssb-telegram') || $(this.element).hasClass('ssb-whatsapp')) {
        $(this.element).show()
      }
    } else {
      if ($(this.element).hasClass('ssb-telegram') || $(this.element).hasClass('ssb-whatsapp')) {
        $(this.element).hide()
      }
    }
  }
  async sharepost(e) {
    e.preventDefault()
    const shareData = { title: this.titleValue, body: this.bodyValue, url: this.urlValue }
    if ( navigator.share) {
      try {
        await navigator.share(shareData)
      } catch(err) {
        alert(err)
      }
    } else {
      alert("O navegador não oferece suporte à API de compartilhamento da Web")
    }
  }

  buttonshare(e) {

    e.preventDefault()
    let url = this.shareValue
    let width = 640
    let height = 480
    let left = 0
    let top = 0
    let opt = `width=${width},height=${height},left=${left},top=${top},menubar=no,status=no,location=no`
    console.log(opt)
    switch (this.buttonValue) {
      case 'twitter':
        url += `?url=${encodeURIComponent(this.urlValue)}&text=${this.titleValue}`
        break
      case 'facebook':
        url += `?u=${encodeURIComponent(this.urlValue)}`
        break
      case 'reddit':
        url += `?url=${encodeURIComponent(this.urlValue)}&newwindow=1`
        break
      case 'telegram':
        url += `?text=${this.titleValue}&url=${encodeURIComponent(this.urlValue)}`
        break
      case 'whatsapp':
        url += `?text=${this.titleValue}%0A${encodeURIComponent(this.urlValue)}`
        break
    }

    window.open(url, 'popup', opt)
  }

}
