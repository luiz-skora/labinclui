// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

//= require jquery3
//= require jquery_ujs


import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "ahoy"


import * as ActiveStorage from "@rails/activestorage"

Rails.start()
Turbolinks.start()


ActiveStorage.start()

window.Rails = Rails;
