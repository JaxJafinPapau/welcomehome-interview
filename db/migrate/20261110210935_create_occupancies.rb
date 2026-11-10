class CreateOccupancies < ActiveRecord::Migration[8.1]
  def change
    create_table :occupancies do |t|
      t.date :move_in
      t.date :move_out

      t.timestamps
    end
  end
end
