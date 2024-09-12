$(document).on('click', '.label-lnk, .li-lnk, .ul-lnk, .tree-lnk', function(){
  console.log('label-lnk')
  var elm = $(this)
  
  if ( !elm.hasClass('disable')) {
    var url = $(this).data('url')
    var target
    
    
    Rails.ajax({
      type: 'patch',
      url: url,
      //dataType: 'JSON',
      dataType: 'script',
      /*
      success: function(data){
        console.log(data)
        if (elm.has('data-target')) {
          target = elm.data(target)
          $(target).html(data)
        }
        
      },//*/
      error: function(data){
        if ($(elm).data('target') ) {
          $(elm.data('target')).html('<div class="msg" style="text-align: center; padding-top: 15px;"> Não foi possível atender sua solicitação.</div>')
        }
        console.log(data)
      },
      complete: function(){},
      beforeSend: function(xhr){
        if ($(elm).data('target') ) {
          $(elm.data('target')).html('<div class="label-lnk-loading"><i class="fas fa-spinner fa-spin"></i></div>')
        }
        return true
      }
    })
  }
}) 

$(document).on('click', '.label-lnk-confirm', function(){
  var msg = $(this).data('message')
  var type =  $(this).data('type') || 'json'
  if (confirm(msg)){
    var url = $(this).data('url')
    Rails.ajax({
      type: 'patch',
      url: url,
      dataType: json,
    })
  }
})

$(document).on('click', '.label-lnk-confirm-script', function(){
  var msg = $(this).data('message')
  if (confirm(msg)){
    var url = $(this).data('url')
    Rails.ajax({
      type: 'patch',
      url: url,
      dataType: 'script',
    })
  }
})

$(document).on('click', '.remove-lnk-confirm', function() {
  var msg = $(this).data('message')
  if ( confirm(msg)) {
    var url = $(this).data('url')
    Rails.ajax({
      type: 'patch',
      url: url,
      dataType: 'script'
    })
  }
})

$(document).on('click', '.alert-lnk', function(){
  alert($(this).data('message'))
})

$(document).on('click', '.frm fieldset.picture', function(){
  var url = $(this).data('url')
  var target = $(this).data('target')

  Rails.ajax({
    type: 'patch',
    url: url,
    dataType: 'script',
    data: 'target='+target
  })
})

/*** Galeria ***/
$(document).on('click','.frm-gallery .gallery .thumbs-container .thumb', function(){
  var action
  var multiple = $(this).parents('.thumbs-container').data().hasOwnProperty('multiple') ? $(this).parents('.thumbs-container').data('multiple') : false
  if ( $(this).hasClass('checked')) {
    action = 'remove'
    $(this).removeClass('checked')
  } else {
    action = 'add'
    if ( !multiple ) {
      $('.thumbs .thumb').removeClass('checked')
    }
    $(this).addClass('checked')

  }

  var url = $(this).parents('.thumbs-container').data('select-url')


  var att_id = $(this).attr('id')

  console.log(url, att_id, multiple)

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'blob_id='+att_id+'&multiple='+multiple+'&add='+action,
    dataType: 'script',
  })

})

$(document).on('change', '.frm-gallery .gallery-blob-selected input#selected_blob_id', function() {

  console.log('change')

  var value = $(this).val()

  if ( value.length > 0 ) {
    $(this).parents('.frm-gallery .gallery-blob-selected').find('.btn-form #submit_blob').show()
  } else {
    $(this).parents('.frm-gallery .gallery-blob-selected').find('.btn-form #submit_blob').hide()
  }

})
$(document).on('click', '.frm-gallery .gallery-blob-selected button#submit_blob.tiny_editor, .frm-gallery .gallery-blob-selected button#submit_blob.pagemaker_image, .frm-gallery .gallery-blob-selected button#submit_blob.pagemaker_file_pdf', function(){
  console.log('submit_blob')

  var url = $(this).data('url')
  var blob_id = $(this).closest('fieldset.btn-form').find('#selected_blob_id').val()

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'blob_id='+blob_id,
    dataType: 'script'
  })

})
/*** Fim galeria ***/


$(document).on('change', 'form input, form select, form textarea', function(){
  $(this).closest('form').find('.message').text('')
})

$(document).on('keypress', 'form textarea', function(){
  $(this).closest('form').find('.message').text('')
})
$(document).on('trix-change', 'form trix-editor', function(){
  $(this).closest('form').find('.message').text('')
})


// Form find
/*
 * INCOMPATÌVEL COM TURBO STREAM *
$(document).on('keyup', '.form-find .filtro-item input[type=text]', function(){
  Rails.fire(this.form, 'submit')
})
$(document).on('change', '.form-find .filtro-item select', function(){
  Rails.fire(this.form, 'submit')
})
*/
//upload files
$(document).on('click','form .add-attachment-btn', function(){
  $(this).parents('form').find('input.add-attachment-field').trigger('click')
})



$(document).on('change', 'form input.add-attachment-field', function(){
  console.log('add attachment')
  var max_size = $(this).data('s')
  var formats = $(this).attr('accept')
  if (validAtt($(this), max_size, formats) ) {
    Rails.fire(this.form, 'submit')
  }

})

function validAtt(file, size, format) {
  var msg = ''
  var f = format.split(', ')
  if( file[0].files[0].size > ( size  )) {
    msg = `Tamanho máximo permitido ${formatBytes(size)}.\n`
  }
  if ( !f.includes(file[0].files[0].type)) {
    msg += "Formatos permitidos "+format
  }

  if ( msg.length == 0 ) {
    return true
  } else {
    alert(msg)
    return false
  }
}

$(document).on('click', '.upload-lnk', function(){
  var target = $(this).data('target')

  $(target).click()

})

$(document).on('change', '.add-anexo .upload', function(){
  let max_size = $(this).data('size')
  console.log($(this)[0].files[0].size)
  if( $(this)[0].files[0].size <= max_size ) {
    $(this).siblings('.msg').text('')
    Rails.fire(this.form, 'submit')
  } else {
    $(this).siblings('.msg').text(`É muito grande.
    Tamanho máximo ${formatBytes(max_size)}.`)
  }
})

function formatBytes(bytes, decimals = 2) {
    if (!+bytes) return '0 Bytes'

    const k = 1024
    const dm = decimals < 0 ? 0 : decimals
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']

    const i = Math.floor(Math.log(bytes) / Math.log(k))

    return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`
}



