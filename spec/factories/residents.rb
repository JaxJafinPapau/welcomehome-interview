FactoryBot.define do
  factory :resident do
    sequence(:name) { |n| "resident #{n}" }
  end
end
