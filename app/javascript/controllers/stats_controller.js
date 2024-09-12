import { Controller } from "@hotwired/stimulus"

import Rails from "@rails/ujs"

export default class Stats extends Controller {
  static values = { refresh: Number, id: String, url: String }

  static get targets() {
      return [ "fields" ]
  }

  refreshTiming(e) {
    //console.log(e, this, this.element.querySelector('select').value)
    this.stopRefresh()
    this.refreshValue = this.element.querySelector('select').value
    console.log(this.refreshValue)
    this.startRefresh()
  }

  initialize() {
    //console.log(this.idValue, this.refreshValue, this.urlValue)

    this.startRefresh()
  }

  diconnect() {
    this.stopRefresh()
  }

  startRefresh() {
    this.refreshTimer = setInterval(() => {
      this.loadData()
    }, this.refreshValue * 1000 )
  }

  stopRefresh() {
    clearInterval(this.refreshTimer)
  }

  loadData() {
    /*
    fetch(this.urlValue)
    .then(respose => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch(function(error) {
      console.log(error)
    })
    */
    let url = this.urlValue
    let el = this.element
    Rails.ajax({
      type: 'get',
      url: url,
      dataType: 'json',
      success: function(data){
        //console.log(data)
        let chartMin = Chartkick.charts['chart-minutes']
        chartMin.updateData(data.minutes)

        let chartSec = Chartkick.charts['chart-seconds']
        chartSec.updateData(data.seconds)

        let urls = JSON.parse(data.urls)
        //console.log(urls)
        let h = ''
        Object.entries(urls).forEach(([k, v]) => {
          h += `<ul class="url l">
                  <li class="name", title="${k}">${k}</li>
                  <li class="count">${v}
                </ul>`
        })
        $(el).find('.stats-data .urls').html(h)

        let visits = JSON.parse(data.visits)
        //console.log(visits)

        h = ''
        Object.entries(visits.device).forEach(([k,v]) => {
          h += `<ul class="device l">
                  <li class="name", title="${k}">${k}</li>
                  <li class="count">${v}
                </ul>`
        })
        $(el).find('.visit-data .device .data').html(h)

        h = ''
        Object.entries(visits.browser).forEach(([k,v]) => {
          h += `<ul class="browser l">
                  <li class="name", title="${k}">${k}</li>
                  <li class="count">${v}
                </ul>`
        })
        $(el).find('.visit-data .browser .data').html(h)

        h = ''
        Object.entries(visits.os).forEach(([k,v]) => {
          h += `<ul class="os l">
                  <li class="name", title="${k}">${k}</li>
                  <li class="count">${v}
                </ul>`
        })
        $(el).find('.visit-data .os .data').html(h)

        h = ''
        Object.entries(visits.city).forEach(([k,v]) => {
          h += `<ul class="city l">
                  <li class="name", title="${k}">${k}</li>
                  <li class="count">${v}
                </ul>`
        })
        $(el).find('.visit-data .city .data').html(h)

      },
      error: function(data){
        console.log(data)
      },
      complete: function() {
        $(el).find('.srt-refresh').hide()
      },
      beforeSend: function(xhr) {
        $(el).find('.srt-refresh').show()
        return true
      }
    })
  }
}
