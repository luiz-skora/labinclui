import { Controller } from "@hotwired/stimulus"

import { FetchRequest } from "@rails/request.js"

import { Turbo } from "@hotwired/turbo-rails"



//import { navigator } from "@hotwired/turbo"


import Rails from "@rails/ujs"

window.Turbo = Turbo

var controller
var refreshComponentes
var pm_component
const componentView = new CustomEvent('visitor-view')
//const componentDraw = new CustomEvent('updated')
export default class extends Controller {
  static values = { index: Number, elms: Array}
  static get targets() {
    return ["field","component"]
  }

  connect() {
    console.log('visitor conect')

    this.getInViewportElements()
    var component = this
    refreshComponentes = setInterval(function(){
      component.getInViewportElements()
      if (component.inViewPortComponents.length === 0) {
        clearInterval(refreshComponentes)
        component.loadAtts()
      }
    }, 500)

  }



  initialize() {
    console.log('initialize')

    this.elms = []
    this.index = 0
    this.count = this.componentTargets.length
    console.log(this.count)
    // /*
    this.componentTargets.forEach((e, i ) => {
      //console.log(i, e)
      this.elms.push( {index: i, status: 'empty', elm: e} )

    })
    //console.log(this.elms)

    //this.showVisibleElements(this.elms)
   // */
  }

  showVisibleElements() {

    this.inViewPortComponents.forEach((e, i) => {
      this.fShow(e)
      console.log(e.status)
    })
    return true
  }

  async getInViewportElements() {
    /*
    this.inViewPortComponents = []
    this.elms.forEach((e, i) => {
      if (e.status == 'empty' && inViewport(e.elm) == true) {
        this.inViewPortComponents.push(e)

      }
    })
    if (this.inViewPortComponents.length > 0 ) {
      const show = await this.showVisibleElements()
      this.getInViewportElements()
    } else {
      this.loadAtts()
    }
    //console.log(this.inViewPortComponents.length)
    return this.inViewPortComponents.length
    */
  }

  async fShow(e) {

    const request = new FetchRequest('get',$(e.elm).data('view-url')+'?element='+$(e.elm).attr('id'), {responseKind: "turbo-stream"} )
    e.status = 'loading'
    $(e.elm).css('border', '2px solid red').html('<div class="loading" style="height: 6em; text-align: center; color: #ddd; font-size: 2em">'+loadingIco()+'</div>')

    this.getInViewportElements()

    const response = await request.perform()
    response.redirect


  }

  loadAtts() {
    console.log('exibir as imagens')
  }

  show(e) {
      let element = $(e.elm)

      var url = element.data('view-url')
      e.status = 'loading'

      const result = Rails.ajax({
        type: 'get',
        url: url,
        //async: false,
        data: 'element='+element.attr('id'),
        success: function(data){
          //console.log('verificar se não está carregando mais de uma vez!',  element.attr('id'))
          Turbo.renderStreamMessage(data)
          element.addClass('loaded').removeClass('loading')
          //console.log(element.attr('class'))
        },
        error: function(err){
          element.html('<div class="msg"> Não foi possivel carregar o elemento.</div>')
          e.status = 'error'
        },
        complete: function() {
          e.status = 'loaded'
          //element.css('border', '0 none transparent')
          //window.dispatchEvent(componentDraw)
          return 'complete'
        },
        beforeSend: function(xhr) {
          e.status = 'loading'
          element.html('<div class="loading" style="height: 6em; font-size: 2em">'+loadingIco()+'</div>')
          element.addClass('loading')
          element.css('border', '3px solid red')
          //console.log(element.attr('class'))

          return true
        }
      })
    }




  componentTargetConnected(element) {
    //console.log('componentTargetConnected', element)

  }


  load_pm() {
    console.log('load-pm')
    this.getInViewportElements()
  }



}



function showElement(e) {

  let element = $(e.elm)

  var url = element.data('view-url')
  e.status = 'loading'

  const result = Rails.ajax({
    type: 'get',
    url: url,
    //async: false,
    data: 'element='+element.attr('id'),
    success: function(data){
      //console.log('verificar se não está carregando mais de uma vez!',  element.attr('id'))
      Turbo.renderStreamMessage(data)
      element.addClass('loaded').removeClass('loading')
        //console.log(element.attr('class'))
      //resolve(data)
    },
    error: function(err){
      element.html('<div class="msg"> Não foi possivel carregar o elemento.</div>')
      e.status = 'error'
      //reject(err)
    },
    complete: function() {
      e.status = 'loaded'
      //element.css('border', '0 none transparent')
      //window.dispatchEvent(componentDraw)
      return 'complete'
    },
    beforeSend: function(xhr) {
      e.status = 'loading'
      element.html('<div class="loading" style="height: 6em; font-size: 2em">'+loadingIco()+'</div>')
      element.addClass('loading')
      element.css('border', '3px solid red')
      //console.log(element.attr('class'))

      return true
    }
  })
  return result
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

  //console.log('inViewPort', elm_top, window_height, scroll_top, window_height + scroll_top , (elm_top <= (window_height + scroll_top ) ? true : false ))

  var s = (elm_top < (window_height + scroll_top ) ? true : false )

  //console.log(s, elm_top, (window_height + scroll_top ))

  return  s
}


function loadingIco(){
  return `<div class="pm-loading"><svg class="svg-inline--fa fa-spinner fa-spin" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="spinner" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M304 48C304 74.51 282.5 96 256 96C229.5 96 208 74.51 208 48C208 21.49 229.5 0 256 0C282.5 0 304 21.49 304 48zM304 464C304 490.5 282.5 512 256 512C229.5 512 208 490.5 208 464C208 437.5 229.5 416 256 416C282.5 416 304 437.5 304 464zM0 256C0 229.5 21.49 208 48 208C74.51 208 96 229.5 96 256C96 282.5 74.51 304 48 304C21.49 304 0 282.5 0 256zM512 256C512 282.5 490.5 304 464 304C437.5 304 416 282.5 416 256C416 229.5 437.5 208 464 208C490.5 208 512 229.5 512 256zM74.98 437C56.23 418.3 56.23 387.9 74.98 369.1C93.73 350.4 124.1 350.4 142.9 369.1C161.6 387.9 161.6 418.3 142.9 437C124.1 455.8 93.73 455.8 74.98 437V437zM142.9 142.9C124.1 161.6 93.73 161.6 74.98 142.9C56.24 124.1 56.24 93.73 74.98 74.98C93.73 56.23 124.1 56.23 142.9 74.98C161.6 93.73 161.6 124.1 142.9 142.9zM369.1 369.1C387.9 350.4 418.3 350.4 437 369.1C455.8 387.9 455.8 418.3 437 437C418.3 455.8 387.9 455.8 369.1 437C350.4 418.3 350.4 387.9 369.1 369.1V369.1z"></path></svg><!-- <i class="fas fa-spinner fa-spin"></i> Font Awesome fontawesome.com --></div>`
}
