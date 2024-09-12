import { Controller } from "@hotwired/stimulus"

import Rails from "@rails/ujs"


const componentView = new CustomEvent('visitor-view')
const componentDraw = new CustomEvent('updated')
export default class extends Controller {

  static get targets() {
      return [ "field" ]
  }



  connect() {
    //console.log( 'para carregar, veja FETCH: https://stimulus.hotwired.dev/handbook/working-with-external-resources ')

    /*
    let element = $(this.element)
    //console.log(this.status, $(this.element).attr('id'))
    if ( this.status == 'empty' && inViewport(this.element)){
      this.show()
    }
    //*/



  }

  click(e) {
    e.preventDefault()
  }

  disconect() {
    //console.log('disconected')
  }


  initialize() {

    this.loaded = false
    this.status = 'empty'
    //console.log('initialize')
    /*
    let element = $(this.element)
    //console.log(this.status, $(this.element).attr('id'))
    if ( this.status == 'empty' && inViewport(this.element)){
      this.show()
    }
    //*/
  }

  show() {
    console.log('show')
    let component = this
    let element = $(this.element)

    if (this.status == 'empty' && inViewport(this.element))  {

      //console.log($(element).attr('class'))
      var url = element.data('view-url')
      this.loading = true
      Rails.ajax({
        type: 'get',
        url: url,
        async: false,
        data: 'element='+element.attr('id'),
        success: function(data){
          //console.log('verificar se não está carregando mais de uma vez!',  element.attr('id'))
          Turbo.renderStreamMessage(data)
          element.addClass('loaded').removeClass('loading')
          //console.log(element.attr('class'))
          component.status = 'loaded'
        },
        error: function(data){
          element.html('<div class="msg"> Não foi possivel carregar o elemento.</div>')
          element.status = 'error'
          component.loading = false
          component.loaded = false
        },
        complete: function() {
          component.status = 'loaded'
          //element.css('border', '0 none transparent')
          //window.dispatchEvent(componentDraw)
        },
        beforeSend: function(xhr) {
          component.status = 'loading'
          element.html(loadingIco())
          element.addClass('loading')
          //element.css('border', '3px solid red')
          //console.log(element.attr('class'))

          return true
        }
      })
    //*/

    } else {
      return component.loaded
    }
  }

  pmLnk() {
    console.log('pmLnk')
  }


}



function inViewport(elm) {
  var elm_top = $(elm).offset().top
  var window_height = $(window).height()
  var scroll_top = $(window).scrollTop()

  if ($(elm).data().hasOwnProperty('viewport')) {
    elm_top = $(elm).position().top
    window_height = $($(elm).data('viewport')).height()
    scroll_top = $($(elm).data('viewport')).scrollTop()
  }

  console.log('inViewPort', elm_top, window_height, scroll_top, window_height + scroll_top , (elm_top <= (window_height + scroll_top ) ? true : false ))

  var s = (elm_top < (window_height + scroll_top ) ? true : false )

  //console.log(s, elm_top, (window_height + scroll_top ))

  return  s
}

function loadingIco(){
  return `<div class="pm-loading"><svg class="svg-inline--fa fa-spinner fa-spin" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="spinner" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M304 48C304 74.51 282.5 96 256 96C229.5 96 208 74.51 208 48C208 21.49 229.5 0 256 0C282.5 0 304 21.49 304 48zM304 464C304 490.5 282.5 512 256 512C229.5 512 208 490.5 208 464C208 437.5 229.5 416 256 416C282.5 416 304 437.5 304 464zM0 256C0 229.5 21.49 208 48 208C74.51 208 96 229.5 96 256C96 282.5 74.51 304 48 304C21.49 304 0 282.5 0 256zM512 256C512 282.5 490.5 304 464 304C437.5 304 416 282.5 416 256C416 229.5 437.5 208 464 208C490.5 208 512 229.5 512 256zM74.98 437C56.23 418.3 56.23 387.9 74.98 369.1C93.73 350.4 124.1 350.4 142.9 369.1C161.6 387.9 161.6 418.3 142.9 437C124.1 455.8 93.73 455.8 74.98 437V437zM142.9 142.9C124.1 161.6 93.73 161.6 74.98 142.9C56.24 124.1 56.24 93.73 74.98 74.98C93.73 56.23 124.1 56.23 142.9 74.98C161.6 93.73 161.6 124.1 142.9 142.9zM369.1 369.1C387.9 350.4 418.3 350.4 437 369.1C455.8 387.9 455.8 418.3 437 437C418.3 455.8 387.9 455.8 369.1 437C350.4 418.3 350.4 387.9 369.1 369.1V369.1z"></path></svg><!-- <i class="fas fa-spinner fa-spin"></i> Font Awesome fontawesome.com --></div>`
}
