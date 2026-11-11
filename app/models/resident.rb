class Resident < ApplicationRecord
  has_many :occupancies, dependent: :nullify
  has_many :units, through: :occupancies
end
