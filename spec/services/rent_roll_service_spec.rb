require 'rails_helper'

RSpec.describe RentRollService, type: :service do
  context '#execute_query' do
    let!(:occupancy) { create(:occupancy) }
    let(:date) { Date.today }
    subject(:results) { described_class.new(date).execute_query }

    it 'should be an ActiveRecord Result' do
      expect(results).to be_an_instance_of(ActiveRecord::Result)
    end

    it 'should have 1 row' do
      expect(results.count).to eq(1)
    end

    it 'contains expected result' do
      expect(results.first['resident_name']).to eq(occupancy.resident.name)
    end
  end
end
