FactoryBot.define do
  factory :unit do
    sequence(:number) { |n| n }
    floor_plan { "Studio" }
  end
end
