# frozen_string_literal: true

namespace :users do
  desc "Creates a new user with the specified email and password. " \
       "Usage: `rake users:create[foo@example.com,password123]`"
  task :create, [:email, :password] => :environment do |_, args|
    email = args[:email]
    password = args[:password]
    User.create!(email:, password:, password_confirmation: password, confirmed_at: Time.now.utc)
  end
end
