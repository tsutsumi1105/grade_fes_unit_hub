# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-autocomplete" # @3.1.0
pin "trix" # @2.1.12
pin "@rails/actiontext", to: "@rails--actiontext.js" # @8.0.100