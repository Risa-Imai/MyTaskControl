FactoryBot.define do
  factory :task do
    title { Faker::Lorem.characters(number:10) }
    progress_status { 1 }
  end
end