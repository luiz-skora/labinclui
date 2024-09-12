# Pin npm packages by running ./bin/importmap


pin "application", preload: true
pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@7.1.3/app/javascript/turbo/index.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"
pin "react", to: "https://ga.jspm.io/npm:react@18.2.0/index.js"
pin "react-dom", to: "https://ga.jspm.io/npm:react-dom@18.2.0/index.js"

#pin "scheduler", to: "https://ga.jspm.io/npm:scheduler@0.23.0/index.js"
pin "ahoy", to: "ahoy.js"
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.2/dist/esm/index.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js"


pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.2/js/fontawesome.js"



pin_all_from "app/javascript/components", under: "components"
pin "@fortawesome/fontawesome-svg-core", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-svg-core@6.1.2/index.es.js"
pin "@fortawesome/free-brands-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-brands-svg-icons@6.1.2/index.es.js"
pin "@fortawesome/free-regular-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-regular-svg-icons@6.1.2/index.es.js"
pin "@fortawesome/free-solid-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-solid-svg-icons@6.1.2/index.es.js"
pin "@rails/actiontext", to: "https://ga.jspm.io/npm:@rails/actiontext@7.0.3-1/app/javascript/actiontext/index.js"

pin "rails-ujs", to: "https://ga.jspm.io/npm:rails-ujs@5.2.8-1/lib/assets/compiled/rails-ujs.js"
pin "@hotwired/turbo", to: "https://ga.jspm.io/npm:@hotwired/turbo@7.1.0/dist/turbo.es2017-esm.js"
pin "@rails/actioncable/src", to: "https://ga.jspm.io/npm:@rails/actioncable@7.0.3/src/index.js"

pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.3-1/lib/assets/compiled/rails-ujs.js"
pin "turbolinks", to: "https://ga.jspm.io/npm:turbolinks@5.2.0/dist/turbolinks.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.3-1/app/assets/javascripts/activestorage.esm.js"
pin "channels", to: "https://ga.jspm.io/npm:channels@0.0.4/channels.js"
pin "domain", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.26/nodelibs/browser/domain.js"

# Outros #
pin "tinymce-rails"
pin "main"
pin "admin"
pin "visitor"
pin "pagemaker"

#pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "trix", to: "https://ga.jspm.io/npm:trix@2.0.0-beta.0/dist/trix.js"
#pin "readable-stream/readable.js", to: "https://ga.jspm.io/npm:readable-stream@2.3.7/readable-browser.js"

#Gráficos
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
