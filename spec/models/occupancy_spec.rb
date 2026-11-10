require 'rails_helper'

RSpec.describe Occupancy, type: :model do
  it { should belong_to(:unit) }
  it { should belong_to(:resident) }
end
