//= require jquery3
//= require jquery_ujs


//import jquery from "jquery"
import "@hotwired/turbo-rails"
import "controllers"
//import Trix from 'trix'
import "@rails/actiontext"
//import Tiny from 'tinymce'

import 'bootstrap'


import "channels"

//import "@rails/request.js"

import "chartkick"
import "Chart.bundle"


console.log('app/javascript/application.js')

//window.jQuery = window.$ = jquery;

/*****************************************
          AUTO LOAD
******************************************/

document.addEventListener("turbo:load", function() {


  console.log('turbo.load')

  var target = document.querySelector('body')

  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      console.log(mutation.type);
    })
  })

  var config = { attributes: true, childList: true, characterData: true }

  observer.observe(target, config)


})


document.addEventListener("turbo:frame-load", function() {


  console.log('turbo.frame-load')

})





/**********************
 * DIRECT UPLOADS
 * ****************/
// direct_uploads.js



addEventListener("direct-upload:initialize", event => {
  const { target, detail } = event
  const { id, file } = detail

  console.log('direct upload')

  if ($(target).data('gallery')) {
    console.log('gallery')
    $('.frm-gallery .thumbs-container').prepend(`<div class="thumb col-fixed" id="new-attachment"><div id="direct-upload-${id}" class="direct-upload direct-upload--pending"><div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div><span class="direct-upload__filename"></span>    </div></div>`)

  } else {

    target.insertAdjacentHTML("beforebegin", `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename"></span>
    </div>
    `)
    target.previousElementSibling.querySelector(`.direct-upload__filename`).textContent = file.name
  }


})

addEventListener("direct-upload:start", event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.remove("direct-upload--pending")
})

addEventListener("direct-upload:progress", event => {
  const { id, progress } = event.detail
  const progressElement = document.getElementById(`direct-upload-progress-${id}`)
  progressElement.style.width = `${progress}%`
})

addEventListener("direct-upload:error", event => {
  event.preventDefault()
  const { id, error } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add("direct-upload--error")
  element.setAttribute("title", error)
})

addEventListener("direct-upload:end", event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add("direct-upload--complete")
})

/****************************************************
     JANELA MODAL
*****************************************************/

$(document).on('click', '.modal-close', function(){
  $('.modal-main').hide()
  $('body').css('overflow', 'auto')
  $('.modal-main').removeClass('no-title no-border transparent')
  $('.modal-main .modal-title').text('')
  $('.modal-main .modal-container').html('')
  $('.modal-main .modal-window .over-modal-window').remove()
})

$(document).on('click', '.over-modal-close', function(){
  var modal_id = $(this).data('id')

  $('.over-modal-window').remove()
})

$(document).on('keydown', function(k){
  if( k.which == 27 && $('.modal-main').is(':visible')) {
    $('.modal-main .modal-close').trigger('click')
  }
})
/*****************************************************/



$(document).on('click', 'li.expand-ico', function(){
  console.log('admin.js')
  if( $(this).hasClass('retract')) {
    $(this).removeClass('retract').addClass('expand')
    $(this).closest('ul').removeClass('retract').addClass('expand')
  } else if( $(this).hasClass('expand')) {
    $(this).removeClass('expand').addClass('retract')
    $(this).closest('ul').removeClass('expand').addClass('retract')
  }
}) 

$(document).on('change', '.frm-new-conf #conf_as_attachment', function(){
  if ( $(this).is(':checked')) {
    $('.frm-new-conf .change-attachment, .frm-new-conf .attachment').show()
  } else {
    $('.frm-new-conf .change-attachment, .frm-new-conf .attachment').hide()
  }
})

$(document).on('click', '.ul-exp-post li', function(){
  if( !$(this).hasClass('no-parent-lnk')) {
    var elm = $(this).closest('.ul-exp-post')
    var url = elm.data('url')
    var details = elm.closest('.ul-item').find('.post-data')
    if ( details.is(':visible') ) {
      details.hide()
    } else {
      details.show()
    }

    if ( !details.hasClass('show-details')) {
      Rails.ajax({
        type: 'patch',
        url: url,
        dataType: 'script',
        success: function() {
          details.addClass('show-details')
        },
        error: function() {
          details.html('<div class="msg" style="text-align: center">Não foi possivel processar sua solicitação.</div>')
        }
      })
    }
  }
})

$(document).on('keyup', '.frm-actions .form-find input', function() {
  var url = $(this).closest('.form-find').data('url')
  var value = $(this).val()

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'query='+value,
    dataType: 'script',
    success: function(data) {},
    error: function(data){},
    complete: function(){},
    beforeSend: function(xhr){
      return true
    }
  })
})

$(document).on('keyup', '.tree-filter .filtro-item.nome input', function() {
  var url = $(this).closest('.tree-filter').data('url')
  var value = $(this).val()
  console.log('tree-filter')
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'query='+value,
    dataType: 'script',
    success: function(data) {},
    error: function(data) {},
    complete: function(data) {},
    beforeSend: function(xhr) {
      return true
    }
  })
})

$(document).on('click', '.frm .device-select.actions .device-li-lnk', function(){
  console.log('device')
  var target = $(this).data('target')
  var url = $(this).data('url')
  $(this).siblings('.device-li-lnk').removeClass('selected')
  $(this).addClass('selected')
  Rails.ajax({
    type: 'patch',
    url: url,
    dataType: 'script',
    success: function(data){},
    error: function(data){},
    complete: function(data){},
    beforeSend: function(xhr){
      $(target).html('<div class="loading" style="text-align-center; font-size: 4em; color: #999;">'+loadingIco()+'</div>')
      return true
    }
  })
})

var left_menu_width
var work_area_width

$(document).on('click', '.left-menu .adm-menu .menu-item.retract', function(){
  left_menu_width = $('.left-menu').width()
  work_area_width = $('.work_area_width').width()
  $('.left-menu .title .title').hide()
  $('.left-menu .menu-item span').hide()
  $('.left-menu').css('width', 'auto')

  $('.work-area').css('margin-left', $('.left-menu').width())
  $('.work-area').width($('.adm-main').width() - ($('.left-menu').width() + 15 ))

  $(this).removeClass('retract').addClass('expand')
  $(this).find('svg.svg-inline--fa').removeClass('fa-circle-chevron-left').addClass('fa-circle-chevron-right')
})

$(document).on('click', '.left-menu .adm-menu .menu-item.expand', function(){

  $('.left-menu').width(left_menu_width)

  $('.left-menu .title .title').show()
  $('.left-menu .menu-item span').show()
  $('.left-menu').css('width', '')

  $('.work-area').css('margin-left', $('.left-menu').width())
  $('.work-area').width($('.adm-main').width() - ($('.left-menu').width() + 15))

  $(this).removeClass('expand').addClass('retract')
  $(this).find('svg.svg-inline--fa').removeClass('fa-circle-chevron-right').addClass('fa-circle-chevron-left')

})


// CATEGORIAS
$(document).on('keyup', '.post-category .filtro-categoria .search-field', function() {
  var items_box = $(this).closest('.post-category').find('.post-categories-box')

  var text = $(this).val().toLowerCase()

  console.log(text)

  items_box.find('.checkbox-label').each(function(){
    //console.log($(this).text().trimLeft().toLowerCase(), $(this).text().trimLeft().toLowerCase().indexOf(text) )
    if ( $(this).text().trimLeft().toLowerCase().indexOf(text) >= 0 ) {
      $(this).show()
    } else {
      $(this).hide()
    }
  })
})

// TAGS
$(document).on('keyup', '.post-tag .filtro-tag .search-field', function(){

  console.log('find tags')

  var url = $(this).closest('.filtro-tag').data('filter-url')
  var text = $(this).val().toLowerCase()
  var container = $(this).closest('fieldset.post-tag')
  var loading_ico = $(this).siblings('.loading')
  var popup = $(this).siblings('.find-tags-popup')

  if ( text.length > 1) {
    Rails.ajax({
      type: 'patch',
      url: url,
      data: 'find='+text,
      dataType: 'json',
      success: function(data){
        console.log(data)
        popup.find('ul.all-tags').html(data.html)
      },
      error: function(data){},
      complete: function(data){
        if ( popup.find('ul.all-tags li').length >= 1 ) {
          popup.show()
        } else {
          popup.hide()
        }
        loading_ico.hide()
      },
      beforeSend: function(xhr){
        loading_ico.show()
        return true
      }
    })
  }


})

$(document).on('keydown', '.post-tag .filtro-tag .search-field', function(k){
  var container = $(this).closest('fieldset.post-tag')
  if ( k.which == 27 ) {
    container.find('.filtro-tag .tags div.find-tags-popup .all-tags li').remove()
    container.find('.filtro-tag .tags div.find-tags-popup').hide()
    container.find('.filtro-tag .search-field').val('')
  }
  if ( k.which == 13 ) {
    k.preventDefault()
    if ( container.find('.filtro-tag .tags div.find-tags-popup .all-tags li').length > 0 ) {
      container.find('.filtro-tag .tags div.find-tags-popup .all-tags li:first').trigger('click')
    } else {
      createAppendTag($(this))
    }
    return false
  }
})

function createAppendTag(elm) {

  console.log('create tag')

  var url = elm.closest('.filtro-tag').data('create-url')
  var tag_name = elm.val()
  var post_id = elm.closest('fieldset.post-tag').data('post-id')
  if ( tag_name.length >= 2 ) {
    Rails.ajax({
      type: 'patch',
      url: url,
      data: 'tag_name='+tag_name,
      dataType: 'script',
      success: function(data){
        console.log(data)

        var new_tag = $('<li class="append_tag" id="tag-'+data.id+'" data-tag-id="'+data.id+'">'+data.nome+'</li>')


        appendTag(new_tag, post_id)

      },
      error: function(){
        alert('Não foi possivel criar a nova Tag.')
      },
      complete: function(){
        elm.siblings('.loading').hide()
        elm.val('');
        elm.siblings('.tags').hide()
      },
      beforeSend: function(xhr) {
        elm.siblings('.loading').show()
        return true
      }
    })
  }
}

$(document).on('click', '.post-tag .filtro-tag .find-tags-popup ul.all-tags li.append_tag', function(){

  var container = $(this).closest('fieldset.post-tag')
  appendTag($(this), $(this).closest('fieldset.post-tag').data('post-id'))

  container.find('.filtro-tag .find-tags-popup').hide()
  container.find('.filtro-tag .search-field').val('')

})

function appendTag(elm, post_id) {

  console.log('append tag')

  var tags_count = $('#tags-post-'+post_id+'.post-tags-box ul.tags li.post-tag').length


  $('#tags-post-'+post_id+' .post-tags-box ul.tags').append('<li class="tag checkbox-label"><input type="checkbox" id="post_tag_'+post_id+'_'+elm.data('tag-id')+'" value="'+elm.data('tag-id')+'" checked="checked" name="post[tag_ids][]"><label>'+elm.text()+'</label><label for="post_tag_'+post_id+'_'+elm.data('tag-id')+'"><i class="far fa-circle-xmark remove-tag" id="remove-tag-'+post_id+'-'+elm.data('tag-id')+'"></i></label></li>')

}



$(document).on('change', '.post-tag .post-tags-box .tags input[type=checkbox]', function(){
  var parent = $(this).closest('li.tag')
  if ( $(this).is(':checked')) {
    parent.removeClass('remove')
    parent.find('.remove-tag').addClass('far fa-times-circle').removeClass('fas fa-undo')
  } else {
    parent.addClass('remove')
    parent.find('.remove-tag').removeClass('far fa-times-circle').addClass('fas fa-undo')
  }
})

$(document).on('click', '.pagemaker .widgets .widget-lnk', function(){
  var url = $(this).data('setup-url')
  var editor_id = $(this).data('editor-id')
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'editor_id='+editor_id,
    dataType: 'script'
  })
})

$(document).on('click', '.pm-component-edit .pm-edit-lnk', function(){
  var url = $(this).data('url')
  var fields = $(this).data('fields')
  var editor_id = $(this).closest('trix-editor').data('editor-id')

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'editor_id='+editor_id+'&fields='+JSON.stringify(fields),
    dataType: 'script'
  })
})

$(document).on('change', '.frm-ad input[type=radio].component, .frm-ad input[type=radio].code', function() {

  $('.frm-ad fieldset.code-component').hide()

  if($(this).is(':checked')) {
    $('.frm-ad fieldset.'+$(this).attr('class')).show()
  }
})

$(document).on('click', '.frm.setup-component .select-image .add-img-lnk', function() {
  var url = $(this).data('url')
  var image = $(this).data().hasOwnProperty('image') ? $(this).data('image') : ''
  var target = $(this).data('target')

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'image='+image+'&target='+target,
    dataType: 'script',
  })
})

$(document).on('change', '.frm-menu-item .set-tipo-link select', function(){
  $(this).closest('.link-route').attr('id', $(this).val())
})

$(document).on('loadAtt', '.mce-content-body .pm-post', function() {
  var w
  var sgid
  $(this).each('figure', function(){
    w = $(this).width()
    sgid = $(this).data('att')
    console.log('LOADATT',w, sgid)
  })
})

$(document).on('click', '.remove-attachment', function(){
  if ( confirm('Tem certeza que deseja excluir o documento anexado?\nEsta ação não poderá ser desfeita.')) {
    var elm = $(this)
    var url = $(this).data('url')

    Rails.ajax({
      type: 'patch',
      url: url
    })
  }
})

$(document).on('change', '.frm-new-aula .avaliacao select#modulo_evaluation_tipo, .frm-evaluation .avaliacao select#modulo_evaluation_tipo', function(){
  //console.log('change')
  Rails.fire(this.form, 'submit')
})

function loadingIco(){
  return `<div class="adm-loading"><svg class="svg-inline--fa fa-spinner fa-spin" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="spinner" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M304 48C304 74.51 282.5 96 256 96C229.5 96 208 74.51 208 48C208 21.49 229.5 0 256 0C282.5 0 304 21.49 304 48zM304 464C304 490.5 282.5 512 256 512C229.5 512 208 490.5 208 464C208 437.5 229.5 416 256 416C282.5 416 304 437.5 304 464zM0 256C0 229.5 21.49 208 48 208C74.51 208 96 229.5 96 256C96 282.5 74.51 304 48 304C21.49 304 0 282.5 0 256zM512 256C512 282.5 490.5 304 464 304C437.5 304 416 282.5 416 256C416 229.5 437.5 208 464 208C490.5 208 512 229.5 512 256zM74.98 437C56.23 418.3 56.23 387.9 74.98 369.1C93.73 350.4 124.1 350.4 142.9 369.1C161.6 387.9 161.6 418.3 142.9 437C124.1 455.8 93.73 455.8 74.98 437V437zM142.9 142.9C124.1 161.6 93.73 161.6 74.98 142.9C56.24 124.1 56.24 93.73 74.98 74.98C93.73 56.23 124.1 56.23 142.9 74.98C161.6 93.73 161.6 124.1 142.9 142.9zM369.1 369.1C387.9 350.4 418.3 350.4 437 369.1C455.8 387.9 455.8 418.3 437 437C418.3 455.8 387.9 455.8 369.1 437C350.4 418.3 350.4 387.9 369.1 369.1V369.1z"></path></svg><!-- <i class="fas fa-spinner fa-spin"></i> Font Awesome fontawesome.com --></div>`
}
