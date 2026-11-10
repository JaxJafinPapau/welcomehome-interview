class Resident < ApplicationRecord
  has_many :occupancies
  has_many :units, through: :occupancies
end
