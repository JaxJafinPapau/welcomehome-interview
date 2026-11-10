class AddResidentToOccupancies < ActiveRecord::Migration[8.1]
  def change
    add_reference :occupancies, :resident, null: false, foreign_key: true
  end
end
