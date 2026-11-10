require 'rails_helper'

RSpec.describe Resident, type: :model do
  it { should have_many(:occupancies) }
  it { should have_many(:units).through(:occupancies) }
end
