class Unit < ApplicationRecord
  has_many :occupancies
  has_many :residents, through: :occupancies
end
