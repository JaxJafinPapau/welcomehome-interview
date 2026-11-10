require 'rails_helper'

RSpec.describe Unit, type: :model do
  it { should have_many(:occupancies) }
end
