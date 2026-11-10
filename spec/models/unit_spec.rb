require 'rails_helper'

RSpec.describe Unit, type: :model do
  it { should have_many(:occupancies) }
  it { should have_many(:residents).through(:occupancies) }
end
