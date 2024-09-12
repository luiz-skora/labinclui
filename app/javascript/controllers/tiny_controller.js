//import Tiny from 'tinymce'

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
  TinyMCERails.configuration.default = {
      selector: "textarea.tinymce",
      cache_suffix: "?v=6.2.0",
      menubar: false,
      paste_merge_formats: true,
      toolbar: ["blocks | bold italic underline strikethrough | alignleft  aligncenter alignjustify alignright | link | galleryButton"],
      plugins: "link,importcss,lists,wordcount,image",
      content_css: ["/assets/tiny.css"],
      height: '600',
      language: 'pt_BR'
    };
    TinyMCERails.initialize('default', {
      setup: function(editor) {
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

      }
    });

}




