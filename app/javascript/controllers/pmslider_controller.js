import { Controller } from "@hotwired/stimulus"

import Rails from "@rails/ujs"

var currentSlide
var currentId = -1
var slider
export default class PmSlider extends Controller {
  static values = { refreshInterval: Number, url: String, id: String, index: Number}

  //static targets = ["slide"]

  static get targets() {
      return [ "slide" ]
  }

  load() {
    //console.log('load')
  }

 // /*
  initialize() {
    slider = this
    this.indexValue = 0
    this.slidesCount = $(this.element).find('.slide').length -1
    this.width = $(this.element).find('.slide-container').width()
    this.height = $(this.element).find('.slide-container').height()


    this.showCurrentSlide()

    if (this.hasRefreshIntervalValue && $(this.element).find('.slide').length > 1 ) {
      this.startRefreshing()
    }

    $(this.element).on('click', '.nav-items .nav-dot', function() {
      //console.log('dot', $(this).data('index'))
      slider.indexValue = $(this).data('index')
      currentId = this.indexValue
      slider.showCurrentSlide()
    })
  }
  preview() {
    this.indexValue--
    this.indexValue = (this.indexValue < 0 ?  this.slidesCount : this.indexValue )

    this.showCurrentSlide()
    //console.log('preview')
  }

  next() {
    this.indexValue++
    this.indexValue = (this.indexValue > this.slidesCount ? 0 : this.indexValue)

    this.showCurrentSlide(100)
    //console.log('next')
  }


  showCurrentSlide(t=0) {
    console.log('showCurrentSlide')
    if ( currentId != this.indexValue) {
      let slide = $(this.element).find('.slide[data-index='+this.indexValue+']')
      currentId = slide.data('index')
      //console.log('showSlide', this.indexValue, this)

      $(this.element).find('.slide').removeClass('active')
      slide.addClass('active')

      slide.css('left', 0)

      $(this.element).find('.nav-items .nav-dot').removeClass('active')
      $(this.element).find('.nav-items .nav-dot[data-index='+currentId+']').addClass('active')

      if ( slide.hasClass('empty') && !slide.hasClass('loading')) {
        this.loadSlide(slide)
      }
    }

  }

  loadSlide(slide) {
    console.log('loadSlide', this.indexValue)
    if(slide.hasClass('empty') && !slide.hasClass('loading')) {
      //console.log('loadSlide')
      var component = this
      var url = slide.data('pmslider-url-value')
      var data = 'element='+slide.attr('id')+'&w='+this.width+'&h='+this.height
      //console.log('loadSlide', this.width, this.height)
      /*
      fetch(url+'?element='+currentSlide.attr('id')+'&w='+this.width+'&h='+this.height)
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
      .then(currentSlide.removeClass('empty'))
      .catch(function(error) { currentSlide.prepend('Indisponível') } )
      */
      Rails.ajax({
        type: 'get',
        url: url,
        async: false,
        data: data,
        success: function(data) {
          //console.log(data)
          Turbo.renderStreamMessage(data)
          slide.removeClass('empty')
          slide.addClass('loaded')
        },
        error: function(data) {
          slide.prepend('Indisponíel')
        },
        complete: function(data){
          $(slide).removeClass('loading')
        },
        beforeSend: function(xhr){
          slide.addClass('loading')
          return true
        }
      })
    }
  }

  animateSlide(t) {
    var slider = this
    var prevId = this.indexValue
    this.indexValue++
    this.indexValue = (this.indexValue > this.slidesCount ? 0 : this.indexValue)
    var nextId = this.indexValue
    //console.log('index', this.indexValue,'prevId', prevId, 'nextId', nextId, 'count', this.slidesCount)
    var prev = $(slider.element).find('.slide[data-index='+prevId+']')
    var next = $(slider.element).find('.slide[data-index='+nextId+']')

    currentId = nextId

    next.css('left', $(slider.element).width()).addClass('active')
    next.animate({left: 0}, t)
    prev.animate({ left: $(slider.element).width() * -1},
      {duration: t,
      done: function() {
          prev.removeClass('active')
          $(slider.element).find('.nav-dot').removeClass('active')
          $(slider.element).find('.nav-dot[data-index='+nextId+']').addClass('active')
          if ( next.hasClass('empty')) {
            slider.loadSlide(next)
          }
        }
      }
    )

  }



  disconnect() {
    this.stopRefreshing()
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.animateSlide(500)
    }, this.refreshIntervalValue)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }

  nextSlide() {

  }


}

