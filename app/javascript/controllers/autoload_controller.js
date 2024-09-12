
import { Controller } from "@hotwired/stimulus"

import Rails from "@rails/ujs"

var next_page
var view_port = $(window)
export default class extends Controller {
  // /*
  click() {
    console.log('auto-load', $(this.element).length)
    var f = this
    var elm = this.element
    var page = $(elm).attr('data-page')
    var query = $(elm).attr('data-query')
    //var query = elm.dataset.query
    var url = $(elm).data('url')

    var more = $(elm).attr('data-more') > 0 ? true : false
    var target = $($(elm).data('target'))

    //console.log('auto-load', page)

    if (inViewPort(elm) && !$(elm).hasClass('loading') && more && next_page ) {
      $(elm).addClass('loading')
      loadNextPage($(elm))
    }




    function loadNextPage(elm) {

      //console.log('loadnextPage')

      Rails.ajax({
        type: 'patch',
        url: url,
        data: 'page='+page+'&query='+query,
        dataType: 'json',
        success: function( data ){
          elm.find('.loading-ico').hide()
          elm.find('.more-label').show()
          elm.find('.next-page-error').hide()

          target.append(data.html)
          elm.attr('data-query', data.query).attr('data-more', data.more)

          //$(elm).data().page++
          $(elm).attr('data-page', data.page)
          if ( !data.more) {
            elm.html('')
          }
          next_page = true

          //console.log('page:', page, 'more:', data.more, 'query:', query )
        },
        error: function(){
          elm.find('.loading-ico').hide()
          elm.find('.more-label').hide()
          elm.find('.next-page-error').show()
        },
        complete: function(){
          $(elm).removeClass('loading')
          if ( next_page ) {
            f.element.click()
          }
        },
        beforeSend: function(xhr) {
          elm.addClass('loading')
          elm.find('.loading-ico').show()
          elm.find('.more-label').hide()
          next_page = false
          return true
        }
      })
    }
  }

  connect() {
    console.log('connect')
    var f = this
    var elm = this.element
    if ($(elm).data().hasOwnProperty('viewport')) {
      view_port = $($(elm).data('container'))
    }
    next_page = true

    this.click()

    view_port.on('scroll', function(e){
      console.log('scroll')
      e.preventDefault()
      if ( inViewPort(elm) > 0  && $(elm).length > 0 && next_page) {
        console.log('scroll')
        f.click()
      }
    })
    $(window).on('resize', function(){
      f.click()
    })
  }

  reload() {
    //console.log('reload')

  }


  disconnect() {
    console.log('desconectado')
    next_page = false

  }


  // */
}

function inViewPort(elm) {
  var elm_top = elm.offsetTop
  var window_height = $(window).height()
  var scroll_top = $(window).scrollTop()
  if ($(elm).data().hasOwnProperty('viewport')) {
    elm_top = $(elm).position().top
    window_height = $($(elm).data('viewport')).height()
    scroll_top = $($(elm).data('viewport')).scrollTop()
  }

      //console.log('inViewPort', elm_top, window_height, scroll_top, window_height + scroll_top , (elm_top <= (window_height + scroll_top ) ? 1 : 0 ))

  return  (elm_top <= (window_height + scroll_top ) ? 1 : 0 )
}
