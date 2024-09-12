import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String}
  static get targets() {
    return ["field"]
  }

  connect() {
    let w = this.element.offsetWidth
    let h = this.element.offsetHeight
    let url = this.urlValue
    let element = this.element.id
    console.log(element,  w, h, url )

    fetch(url+'?element='+element+'&w='+w+'&h='+h)
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))

  }

  initialize() {

  }
}
