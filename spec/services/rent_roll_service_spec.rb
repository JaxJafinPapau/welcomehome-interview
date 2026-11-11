require 'rails_helper'

RSpec.describe RentRollService, type: :service do
  subject(:service) { described_class.new(date) }
  let(:date) { Date.today }

  context '#execute_query' do
    let!(:occupancy) { create(:occupancy) }

    it 'should be an ActiveRecord Result' do
      expect(service.execute_query).to be_an_instance_of(ActiveRecord::Result)
    end

    it 'should have 1 row' do
      expect(service.execute_query.count).to eq(1)
    end

    it 'contains expected result' do
      expect(service.execute_query.first['resident_name']).to eq(occupancy.resident.name)
    end
  end
end
