# Since it's our own file, we don't need to specify the "to" option
# (importmap will find it automatically). preload: true tells the browser
# to load the file as soon as possible, without waiting for the DOM to
# be ready, but not to execute it until it's been explicitly imported.
pin "application", preload: true
# We specify the "to" option here because the file is from a third-party library.
# We import it using: import "@hotwired/turbo-rails"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@popperjs/core", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true

pin "jquery", to: "jquery.min.js", preload: true
pin "choose_template"
