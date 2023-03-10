FactoryBot.define do
  factory :item do
    merchant
    name { Faker::Coffee.blend_name }
    description { Faker::Coffee.notes }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end
