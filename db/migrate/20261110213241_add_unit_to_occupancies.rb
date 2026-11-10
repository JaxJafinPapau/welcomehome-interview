class AddUnitToOccupancies < ActiveRecord::Migration[8.1]
  def change
    add_reference :occupancies, :unit, null: false, foreign_key: true
  end
end
