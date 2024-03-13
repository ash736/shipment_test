FactoryBot.define do
  factory :shipment do
    source { Faker::Address.city }
    target { Faker::Address.city }
    item { Faker::Commerce.product_name }
    association :customer
    association :delivery_partner
  end
end
