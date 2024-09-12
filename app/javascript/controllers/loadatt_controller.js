import { Controller } from "@hotwired/stimulus"


//https://stackoverflow.com/questions/70837739/dynamicly-add-a-button-that-is-linked-to-an-action
import Rails from "@rails/ujs"



export default class extends Controller {
  static get targets() {
      return [ "field" ]
  }

  connect() {
    console.log('load att connect')
    let element = $(this.element)
    let sgid = $(element).data('att')
    let w = this.element.offsetWidth
    let h = this.element.offsetHeight

    console.log(sgid)

    var result = fetch('/load_att_src?att='+sgid+'&w='+w+'&h='+h)
    .then(response => response.text())
    .then(json => {
      $(element).find('img').attr('src', JSON.parse(json).src)
    })



  }

  initialize() {
    console.log('load_att initialize')
  }

  load() {
    console.log('load_att load()')
  }


}
