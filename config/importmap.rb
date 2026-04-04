# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.16
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.13

pin_all_from "app/javascript/controllers", under: "controllers", preload: false

pin "chart.js/auto", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.7/auto/+esm"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.0.300
