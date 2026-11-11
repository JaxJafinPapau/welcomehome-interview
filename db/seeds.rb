# Refactor this if there's time for better error handling, etc.

path = Rails.root.join 'assets', 'units-and-residents.csv'
CSV.foreach(path, headers: true) do |row|
  unit = Unit.find_or_create_by(number: row["unit"], floor_plan: row["floor_plan"])
  if row["resident"]
    resident = Resident.find_or_create_by(name: row["resident"])
    move_in = row["move_in"] ? Date.strptime(row["move_in"], "%m/%d/%Y") : nil
    move_out = row["move_out"] ? Date.strptime(row["move_out"], "%m/%d/%Y") : nil

    occupancy = Occupancy.find_or_create_by(resident:, unit:, move_in:, move_out:)
  end
end
