# arob

A bunch of useful tools I've made to make life a little bit easier.

## Dev Setup

NOTE: These setup steps are currently all tailored for development on MacOS. If you wish to
contribute using a non-MacOS device, please reach out and we can get you sorted out. If you manage to get it sorted out yourself, please consider opening a PR with your setup steps!

### Dependancies

#### Recommendations

* Use [Homebrew](https://brew.sh/) to install mac specific tooling such as `rbenv`

* Use [rbenv](https://github.com/rbenv/rbenv) to manage local ruby versions

#### Necessary Dependancies*

* Ruby installed locally (see the [.ruby_version](.ruby-version) file for the current version)

* [Bundler](https://bundler.io/) installed locally for the current ruby version

* [PostgreSQL](https://www.postgresql.org/) version `13.5`

### Setup Instructions

Note: All these steps should be executed from the root of the project folder unless otherwise specified

1. Create a local postgres server running version `13.5`
2. Run `bin/setup` to setup the app
3. Run `bin/dev` to run the app

### Running Tests

#### Rails Tests

To run tests simply run the command:

    rails test

#### Linting

To check for lint issues you can simply run:

    rubocop

#### Security Tests

You can run the security CI tests yourself with:

    bundle exec bundler-audit --update

and

    bundle exec brakeman -q -w2

#### FactoryBot Tests

CI currently checks to ensure that all declared factories can be built without error. You can run this test yourself
with the command:

    bundle exec rake factory_bot:lint

### Deployment

Currently, this app is not deployed anywhere! It's still in development!
