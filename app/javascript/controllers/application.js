

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


console.log('application in controller')

import "ahoy"



import 'bootstrap'
//import "@fortawesome/fontawesome-free/css/all"
/*
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("@rails/actiontext")
require("jquery")
require("channels")
//*/
import {far} from "@fortawesome/free-regular-svg-icons"
import {fas} from "@fortawesome/free-solid-svg-icons"
//import {fab} from "@fortawesome/free-brands-svg-icons"
import {library} from "@fortawesome/fontawesome-svg-core"
import "@fortawesome/fontawesome-free"
library.add(far, fas)


