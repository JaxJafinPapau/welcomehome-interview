class Unit < ApplicationRecord
  has_many :occupancies, dependent: :nullify
  has_many :residents, through: :occupancies
end
