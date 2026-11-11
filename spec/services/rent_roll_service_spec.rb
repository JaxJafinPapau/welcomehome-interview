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

  context '#calculate_vacancies' do
    let!(:current_occupancy) { create(:occupancy) }
    let!(:future_occupancy) { create(:occupancy, move_in: nil, move_out: nil) }
    let!(:past_occupancy) { create(:occupancy, move_in: Date.today - 2.days, move_out: Date.today - 1.day, unit: vacant_unit) }
    let!(:vacant_unit) { create(:unit) }
    let(:rows) { service.execute_query }

    it 'should calculate 1 vacancy' do
      expect(service.calculate_vacancies(rows)).to eq(1)
    end
  end

  context '#calculate_occupancies' do
    let!(:current_occupancy) { create(:occupancy) }
    let!(:future_occupancy) { create(:occupancy, move_in: nil, move_out: nil) }
    let!(:past_occupancy) { create(:occupancy, move_in: Date.today - 2.days, move_out: Date.today - 1.day, unit: vacant_unit) }
    let!(:vacant_unit) { create(:unit) }
    let(:rows) { service.execute_query }

    it 'should calculate 1 occupancy' do
      expect(service.calculate_occupancies(rows)).to eq(1)
    end
  end

  context '#calculate_leased_units' do
    let!(:current_occupancy) { create(:occupancy) }
    let!(:future_occupancy) { create(:occupancy, move_in: nil, move_out: nil) }
    let!(:past_occupancy) { create(:occupancy, move_in: Date.today - 2.days, move_out: Date.today - 1.day, unit: vacant_unit) }
    let!(:vacant_unit) { create(:unit) }
    let(:rows) { service.execute_query }

    it 'should calculate 2 leased units' do
      expect(service.calculate_leased_units(rows)).to eq(2)
    end
  end
end
