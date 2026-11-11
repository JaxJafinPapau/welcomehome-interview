FactoryBot.define do
  factory :occupancy do
    move_in { Date.today }
    move_out { Date.today + 1.year }
    unit
    resident
  end
end
