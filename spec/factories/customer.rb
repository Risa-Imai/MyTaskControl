FactoryBot.define do
  factory :customer do
    last_name { Faker::Lorem.characters(number:10) }
    first_name { Faker::Lorem.characters(number:10) }
    introduction { Faker::Lorem.characters(number:150) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end
end