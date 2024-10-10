# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.10
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.10
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @7.2.100

pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
