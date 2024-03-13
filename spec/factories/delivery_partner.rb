FactoryBot.define do
  factory :delivery_partner do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    active_for_delivery { true }
  end
end
  