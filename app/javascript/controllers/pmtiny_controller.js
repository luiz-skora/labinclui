import { Controller } from "@hotwired/stimulus"

import Rails from "@rails/ujs"

export default class extends Controller {

  static get targets() {
      return [ "field" ]
  }

  connect() {
    console.log('connect', this)
    initializeEditor()
    var elm = this.element
    //$(elm).trigger('initializeEditor')
  }

  click() {
    console.log('tinymce click')
  }

  disconect() {
    console.log('disconected')
    tinymce.remove('textarea.tinymce')
  }

  initialize() {
    console.log('initialize')
    initializeEditor()
  }
}


function initializeEditor() {
  console.log('initializeEditor')
  tinymce.remove('textarea.tinymce')

  tinymce.PluginManager.add('pmcolumns', (editor) =>{
    var element
    var contextMenuItems = () => {
      return  [{
        type: 'submenu',
        text: 'Colunas',
        getSubmenuItems: () => [
          {
            type: 'item',
            text: 'Editar',
            onAction: () => {
              var cols = ''
              var target = editor.targetElm
              var url = $(target).data('columns-url')
              var editor_id = $(target).data('editor-id')
              if ( $(element).hasClass('pm-row') || $ (element).closest('.pm-row')) {
                if (!$(element).hasClass('pm-row')) {
                  cols = $(element).closest('.pm-row')
                } else {
                  cols = $(element)
                }
                var columns_id = $(cols).attr('id')
                var columns_data = $(cols).attr('data-fields')
                columnsDialog(target, url, editor_id, columns_id, columns_data)
              }
            }
          },
          {
            type: 'item',
            text: 'Linha acima',
            onAction: () => {
              var cols
              if ( $(element).hasClass('pm-row') || $ (element).closest('.pm-row')) {
                if (!$(element).hasClass('pm-row')) {
                  cols = $(element).closest('.pm-row')
                } else {
                  cols = $(element)
                }
                $('<p><br data-mce-bogus="1"></p>').insertBefore($(cols))
              }
            }
          },
          {
            type: 'item',
            text: 'Linha abaixo',
            onAction: () => {
              var cols
              if ( $(element).hasClass('pm-row') || $ (element).closest('.pm-row')) {
                if (!$(element).hasClass('pm-row')) {
                  cols = $(element).closest('.pm-row')
                } else {
                  cols = $(element)
                }
                $('<p><br data-mce-bogus="1"></p>').insertAfter($(cols))
              }
            }
          }
        ]
      }]
    }

    editor.ui.registry.addContextMenu('columns', {
      update: (e) => {
        element = e
        return ( !($(e).hasClass('pm-row') || $(e).closest('.pm-row').length) ? '' : contextMenuItems() )
      }
    })

  })

  tinymce.PluginManager.add('pmcomponents', (editor) => {
    var element
    var contextMenuItems  = () => {
      return [{
        type: 'submenu',
        text: 'Componente',
        getSubmenuItems: () => [
        {
          type: 'item',
          text: 'Edit',
          onAction: () => {
            var target = editor.targetElm
            var url = $(target).data('components-url')
            var editor_id = $(target).data('editor-id')
            if ( $(element).hasClass('pm-component') || $(element).closest('.pm-component') ) {
              if ( !$(element).hasClass('pm-component')) {
                element = $(element).closest('.pm-component')
              } else {
                element = $(element)
              }
              if ($(element).parents('.pm-component').length > 0 ) {
                element = $(element).parents('.pm-component').last()
              }
              componentDialog(element, editor_id, url)
            }
          }
        },
        {
          type: 'item',
          text: 'Linha acima',
          onAction: () => {
            if ( $(element).hasClass('pm-component') || $(element).closest('.pm-component') ) {
              if ( !$(element).hasClass('pm-component')) {
                element = $(element).closest('.pm-component')
              } else {
                element = $(element)
              }
              if ($(element).parents('.pm-component').length > 0 ) {
                element = $(element).parents('.pm-component').last()
              }
              $('<p><br data-mce-bogus="1"></p>').insertBefore($(element))
            }
          }
        },
        {
          type: 'item',
          text: 'Linha abaixo',
          onAction: () => {
            if ( $(element).hasClass('pm-component') || $(element).closest('.pm-component') ) {
              if ( !$(element).hasClass('pm-component')) {
                element = $(element).closest('.pm-component')
              } else {
                element = $(element)
              }
              if ($(element).parents('.pm-component').length > 0 ) {
                element = $(element).parents('.pm-component').last()
              }
              $('<p><br data-mce-bogus="1"></p>').insertAfter($(element))
            }
          }
        }
        ]
      }]
    }
    editor.ui.registry.addContextMenu('component', {
      update: (e) => {
        element = e
        return ( !($(e).hasClass('pm-component') || $(e).closest('.pm-component').length) ? '' : contextMenuItems() )
      }
    })
  })

  TinyMCERails.configuration.pm = {
    selector: "textarea.tinymce",
    cache_suffix: "?v=6.2.0",
    menubar: false,
    paste_merge_formats: true,
    toolbar: ["blocks | bold italic underline strikethrough | alignleft  aligncenter alignjustify alignright | link | componentsButton columnsButton galleryButton code"],
    plugins: "link,importcss,lists,wordcount,image, pmcolumns, pmcomponents, code",
    content_css: ["/assets/tiny.css"],
    height: '400',
    language: 'pt_BR',
    contextmenu: 'link image columns component',
    extended_valid_elements: "+@[data-fields|id|class|sgid|data-images-url-value|data-pmslider-refresh-interval-value|data-index|data-id|data-pmslider-target-value|data-controller|data-action|data-share-url-value], action-text-attachment[class|id|sgid], script[type|src], form[data-controller|data-action|data-share-url-value], label[data-controller]",


    //|data-controller|data-visitor-target|data-action|data-view-url|data-sgid]',
    custom_elements: 'action-text-attachment',
    extended_valid_elements: "action-text-attachment[class|id|sgid]",
    noneditable_leave_contenteditable: true,
    noneditable_class: 'pm-component',
    editable_class: 'e-pm',

  };
   //https://www.tiny.cloud/docs-3x/reference/TinyMCE3x@Plugins/Plugin3x@noneditable/?gclid=CjwKCAjw8JKbBhBYEiwAs3sxNwKlC63lK0KcXdPaU1C-VzPinqGjeE-DZnm_BKuVwj4-e0VEm60m5BoCD_8QAvD_BwE


  /*

  */
  TinyMCERails.initialize('pm', {

    setup: function(editor) {

      //Galeria de imagens
      editor.ui.registry.addButton('galleryButton', {
        icon: 'gallery',
        tooltip: 'Galeria',
        onAction: (_) => showGallery(editor)
        //editor.insertContent(`<spam>Botão Clicado<spam>`)
      })
      function showGallery(e) {
        var target = e.targetElm
        var url = $(target).data('gallery-url')
        var editor_id = $(target).data('editor-id')
        console.log('showGallery', target)
        //alert('showGallery')

        Rails.ajax({
          type: 'patch',
          url: url,
          data: 'editor_id='+editor_id,
          dataType: 'script'
        })
      }

      //Componentes
      editor.ui.registry.addButton('componentsButton', {
        text: 'Componentes',
        tooltip: 'Componentes',
        onAction: (_) => showComponents(editor)
      })
      function showComponents(e) {
        var target = e.targetElm
        var url = $(target).data('components-url')
        var editor_id = $(target).data('editor-id')
        Rails.ajax({
          type: 'patch',
          url: url,
          data: 'editor_id='+editor_id,
          dataType: 'script'
        })
      }
      //Colunas
      editor.ui.registry.addButton('columnsButton', {
        text: 'Colunas',
        tooltip: 'Colunas',
        onAction: (_) => showColumns(editor)
      })
      function showColumns(e) {
        var target = e.targetElm
        var url = $(target).data('columns-url')
        var editor_id = $(target).data('editor-id')
        columnsDialog(target, url, editor_id, '', '', '')
      }

      // /*
      editor.on('init', function(e){
        console.log('editor init')
        var url
        var components = e.target.selection.select(e.target.dom.select('div.pm-component'))
        console.log(components)
        $.each(components, function(){
          loadComponent(this)
        })
      })
      //*/
    }

  });// initialize pm

}

function loadComponent(elm) {
  console.log(elm)
  var url = $(elm).data('view-url')

  Rails.ajax({
    type: 'patch',
    url: url,
    dataType: 'json',
    success: function(data){
      elm.innerHTML = data.html
    },
    error: function(data){
      elm.innerHTML = '<div class="msg"> Não foi possivel carregar o componente.</div>'
    },
    complete: function() {
      $(elm).find('div.pm-component').each(function(){
        loadComponent(this)
      })

    },
    beforeSend: function(xhr) {
      elm.innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin">Carregando...</i></div>'

      return true
    }
  })
}

function columnsDialog(target, url, editor_id, columns_id, columns_data) {

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'editor_id='+editor_id+'&columns_id='+columns_id+'&columns_data='+columns_data,
    dataType: 'script'
  })
}

function componentDialog(element, editor_id, url) {
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'pm_id='+element.attr('id')+'&editor_id='+editor_id+'&sgid='+element.attr('sgid'),
    dataType: 'script',

  })
}
