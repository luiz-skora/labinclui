$(document).on('change', '.frm.setup-component .setup-widget-col .setup-form fieldset input[type="checkbox"]', function(){
  if($(this).is(':checked') ) {
    $(this).val('1')
  } else {
    $(this).val('0')
  }
})
$(document).on('change', '.frm.setup-component .setup-widget-col .setup-form', function() {
 console.log('change')
  var values = {}
  $(this).closest('.setup-form').find('fieldset .field').each(function(){

      values[$(this).attr('name')] = $(this).val()

  })

  console.log(values, JSON.stringify(values))

  $(this).closest('.setup-form').find('input.fields-values').val(JSON.stringify(values)).trigger('preview')
})

$(document).on('preview', '.frm.setup-component .setup-widget-col .setup-form input.fields-values', function(){
  var container = $(this).closest('.setup-component')
  var url = container.data('preview-url')
  var data = $(this).val()
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'fields='+data,
    dataType: 'json',
    success: function(data){
      console.log(data.fields)
      console.log(data.html)
      container.find('.setup-preview').html(data.html)
      container.find('input.component_data').val(data.fields)
    },
    error: function() {
      container.find('.setup-preview').html('<div class="msg">Não foi possivel renderizar o elemento</div>')
    },
    complete: function() {

    },
    beforeSend: function(xhr){
      container.find('.setup-preview').html('<div style="font-size: 2em; text-align: center; color: #999;"><i class="fas fa-spinner fa-spin"></i></div>')
      return true;
    }
  })
})

$(document).on('click', '.frm.setup-component .builder-button, .frm.setup-columns .builder-button', function(){

  console.log('builder-button')
  var url = $(this).data('url')
  var editor_id = $(this).data('editor-id')
  var fields = $(this).siblings('input.component_data').val()
  var component_id = $(this).siblings('input.component_id').val()
  var pm_id = $(this).siblings('input.pm_id').val()
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'editor_id='+editor_id+'&component_id='+component_id+'&fields='+fields+'&pm_id='+pm_id,
    dataType: 'script'
  })

})
/* COLUNAS */
$(document).on('change', '.setup-columns .frm.setup-form select.number_columns', function(e){
  console.log('chage columns')
  e.preventDefault()

  var url = $(this).data('change-url')
  var cols = $(this).val()
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'cols='+cols,
    dataType: 'script',
    complete: function() {
      $('.frm.setup-columns .setup-widget-col .frm.setup-form .field').first().trigger('change')
    },
    beforeSend: function(xhr) {
      $('.setup-columns .frm.setup-form .columns_fields').html('<div class="label-lnk-loading"><i class="fas fa-spinner fa-spin"></i></div>')
      $('.setup-columns .frm.setup-preview').html('<div class="label-lnk-loading"><i class="fas fa-spinner fa-spin"></i></div>')
      return true
    }
  })
})

$(document).on('change', '.frm.setup-columns .setup-widget-col .frm.setup-form .field', function(){
  var values = {colunas: $(this).closest('.setup-form').find('select.number_columns').val()}
   $(this).closest('.setup-form').find('fieldset .field').each(function(){
    values[$(this).attr('name')] = $(this).val()
  })

  console.log(values, JSON.stringify(values))

  $(this).closest('.setup-form').find('input.fields-values').val(JSON.stringify(values)).trigger('preview')

})

$(document).on('preview', '.frm.setup-columns .setup-widget-col .setup-form input.fields-values', function() {
  var container = $(this).closest('.setup-columns')
  var url = container.data('preview-url')
  var data = $(this).val()

  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'fields='+data,
    dataType: 'json',
    success: function(data) {
      console.log(data.fields)
      container.find('.setup-preview').html(data.html)
      container.find('input.component_data').val(data.fields)
    },
    error: function(){

    },
    complete: function(){

    },
    beforeSend: function(xhr){
      container.find('.setup-preview').html('<div style="font-size: 2em; text-align: center; color: #999;"><i class="fas fa-spinner fa-spin"></i></div>')
      return true;
    }
  })
})
