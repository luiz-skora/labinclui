var sliderTimer
document.addEventListener("turbolinks:load", function() {
  console.log('visitor turbolink:load')

  $('html').attr('data-w', window.innerWidth).attr('data-h', window.innerHeight)

  ///*
  loadImages()
  window.addEventListener('scroll', () => { loadImages()})

  slidersInitialize()

  loadAtt()

  window.addEventListener('scroll', () => { loadAtt()})
  //*/

  InitializeSharePostButtons()
})

$(document).on('click', '.pm-component .lnk', function() {
  console.log('lnk')
  var url = $(this).data('url')
  Rails.ajax({
    type: 'get',
    url: url
  })
})

$(document).on('click', '.navbar-expand .navbar-toggler', function(){
  if( $(this).closest('.navbar-expand').hasClass('expand')) {
    $(this).closest('.navbar-expand').removeClass('expand')
    $(this).closest('.navbar-expand').addClass('retract')
  } else {
    $(this).closest('.navbar-expand').removeClass('retract')
    $(this).closest('.navbar-expand').addClass('expand')
  }
})

$(document).on('click', '.navbar-expand .nav-link', function(){
  $(this).closest('.navbar-expand').removeClass('expand')
  $(this).closest('.navbar-expand').addClass('retract')

})

function inViewport(elm) {

  var elm_top = elm.getBoundingClientRect().top
  var window_height = window.innerHeight + window.scrollY
  //document.querySelector('body').getBoundingClientRect().height + window.scrollY


  //console.log('inViewPort', elm_top, window_height)

  return  ( elm_top <= window_height ? 1 : 0 )
}

function loadImages() {
  $(document).find('.pm_image').each(function(e) {
    if ( inViewport(this) == 1  && !($(this).hasClass('loading')  || $(this).hasClass('loaded')) ) {

      loadImage(this)
    }
  })
}

function loadAtt() {

  $(document).find('figure[data-att]').each(function(){
    let el = this
    if( inViewport(this) == 1 && !($(this).hasClass('loading') || $(this).hasClass('loaded'))) {
      let sgid = $(this).data('att')
      let w = $(this).find('img').width()
      let h = $(this).find('img').height()

      Rails.ajax({
        type: 'patch',
        url: '/load_att_src',
        data: `att=${sgid}&w=${w}&h=${h}`,
        dataType: 'json',
        success: function(data) {
          console.log(data)
          $(el).find('img').attr('src', data.src).attr('alt', data.alt)
        },
        compete: function() {
          $(el).removeClass('loading').addClass('loaded')
        },
        beforeSend: function(xhr) {
          $(el).addClass('loading')
          return true
        }
      })
    }
  })
}

function loadImage(elm) {
  let w = elm.offsetWidth
  let h = elm.offsetHeight
  let url = $(elm).data('images-url-value')
  let element = elm.id
  Rails.ajax({
    type: 'patch',
    url: url,
    data: 'element='+element+'&w='+w+'&h='+h,
    dataType: 'json',
    success: function(data){
      if ( data.blob.file > 0 ) {
        $(elm).html(`<img src="${data.blob.url}" width="${data.blob.width}" height="${data.blob.height}" alt="${data.blob.alt}">`)
      }
    },
    complete: function() {
      $(elm).removeClass('loading').addClass('loaded')
    },
    beforeSend: function(xhr){
      $(elm).addClass('loading')
      return true
    }
  })
}


function slidersInitialize() {
  $(document).find('.pm-slider').each(function() {
    //static values = { refreshInterval: Number, url: String, id: String, index: Number}
    //this.index = 0
    //this.slidesCount = $(this).find('.slide').length - 1
    $(this).attr('data-current', 0)
    $(this).attr('data-count', $(this).find('.slide').length - 1)
    this.width = $(this).find('.slide-container').width()
    this.height = $(this).find('.slide-container').height()
    let el = this

    loadSlides(this)


    sliderTimer = setInterval(() => {
      animateSlider(el, 500)
      },$(this).data('pmslider-refresh-interval-value')
    )


  })
}

function loadSlides(el) {
  $(el).find('div.slide').each(function() {
    if ( $(this).hasClass('empty') && !($(this).hasClass('loading') || $(this).hasClass('loaded'))) {
      loadSlide(this)
    }
  })
}

function loadSlide(el) {
  let w = el.offsetWidth
  let h = el.offsetHeight
  let url = $(el).data('pmslider-url-value')
  let element = el.id
  Rails.ajax({
    type: 'patch',
    url: url,
    data: `element=${element}&w=${w}&h=${h}`,
    dataType: 'json',
    success: function(data) {
      //console.log(data)
      if ( data.blob.file > 0 ) {
        //console.log(`.slide-${el.id}`)
        $(el).find(`#slide-${el.id}`).html(`<img src="${data.blob.url}" width="${data.blob.width}" height="${data.blob.height}" alt="${data.blob.alt}">`)
      }
    },
    complete: function() {
      $(el).removeClass('loading').addClass('loaded')
    },
    beforeSend: function(xhr) {
      $(el).removeClass('empty').addClass('loading')
      return true
    }
  })
}

function animateSlider(el, t) {
  if( $(el).length > 0) {
    animateSlide(el, t)
  } else {
    clearInterval(el.sliderTimer)
  }
}

function animateSlide(el, t) {

  let index = $(el).attr('data-current')
  let current = $(el).find(`.slide[data-index=${index}]`)
  let count = $(el).data('count')
  index++
  index = ( index <= count ? index : 0 )


  let next = $(el).find(`.slide[data-index=${index}]`)

  next.css('left', $(el).width()).addClass('active')
  next.animate({left: 0}, t)
  current.animate({left: $(el).width() * -1},
    { duration: t,
      done: function(){
        current.removeClass('active')
        $(el).find('.nav-dot').removeClass('active')
        $(el).find(`.nav-dot[data-index=${index}]`).addClass('active')
      }
    }
  )
  current.css('left', 0)
  $(el).attr('data-current', index)
}

$(document).on('click', '.pm-slider .arrow-ico', function(e) {
  e.preventDefault()
  let direction = $(this).data('direction')
  let el = $(this).closest('.pm-slider')
  let index = $(el).attr('data-current')
  $(el).find(`.slide`).addClass('active').css('left', 0)
  let count = $(el).data('count')
  if (direction == 'l' ) {
    index--
    index = (index < 0 ? count : index )
  }
  if ( direction == 'r') {
    index++
    index = (index > count ? 0 : index)
  }

  $(el).find('.slide').removeClass('active')
  $(el).find(`.slide[data-index=${index}]`).addClass('active')
  $(el).find('.nav-dot').removeClass('active')
  $(el).find(`.nav-dot[data-index=${index}]`).addClass('active').css('left', 0)
  $(el).attr('data-current', index)

})

$(document).on('click', '.pm-slider .nav-dot', function(e) {
  e.preventDefault()
  let el = $(this).closest('.pm-slider')
  let index = $(this).data('index')

  el.find('.nav-dot').removeClass('active')
  $(this).addClass('active')
  el.find('.slide').removeClass('active')
  el.find(`.slide[data-index=${index}]`).addClass('active').css('left', 0)
  el.attr('data-current', index)

})

function InitializeSharePostButtons() {
  if (!navigator.share) {
    $('.api-share-button').hide()
  }
  if ($('.content').hasClass('Mobile') ) {
    $('.ssb-telegram').show()
    $('.ssb-whatsapp').show()
  } else {
    $('.ssb-telegram').hide()
    $('.ssb-whatsapp').hide()
  }
}

$(document).on('click', '.share-button', function(e){
  e.preventDefault()
  let url = $(this).data('sharepost-share-value')
  let width = ($(window).width() >= 640 ? 640 : $(window).width() )
  let height = $(window).height() >= 480 ? 480 : $(window).height()
  let left = 0
  let top = 0
  let opt = `width=${width},height=${height},left=${left},top=${top},menubar=no,status=no,location=no`

  switch ( $(this).data('sharepost-button-value')) {
    case 'twitter':
      url += `?url=${encodeURIComponent($(this).data('sharepost-url-value'))}&text=${$(this).data('sharepost-title-value')}`
      break
    case 'facebook':
      url += `?u=${encodeURIComponent($(this).data('sharepost-url-value'))}`
      break
    case 'reddit':
      url += `?url=${encodeURIComponent($(this).data('sharepost-url-value'))}&newwindow=1`
      break
    case 'telegram':
      url += `?text=${$(this).data('sharepost-title-value')}&url=${encodeURIComponent($(this).data('sharepost-url-value'))}`
      break
    case 'whatsapp':
      url += `?text=${$(this).data('sharepost-title-value')}%0A${encodeURIComponent($(this).data('sharepost-url-value'))}`
      break
  }
  //console.log(url)
  window.open(url, 'popup', opt)
})

$(document).on('click', '.api-share-button', function(e){

  var el = this

  async function sharePost(e) {
    e.preventDefault()

    const shareData = {
      title: $(el).data('sharepost-title-value'),
      body: $(el).data('sharepost-body-value'),
      url: $(el).data('sharepost-url-value')
    }
    if ( navigator.share ) {
      try {
        await navigator.share(shareData)
      } catch(err) {
        alert(err)
      }
    } else {
      alert("O navegador não oferece suporte à API de compartilhamento da Web")
    }
  }


  sharePost(e)


})


