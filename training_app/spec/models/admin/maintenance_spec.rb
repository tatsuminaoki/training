# frozen_string_literal: true

require 'rails_helper'

describe Admin::Maintenance do
  let!(:start_time) { '2010-01-01 00:00:00' }
  let!(:end_time) { '2020-12-31 23:59:59' }
  let!(:maintenance) { Admin::Maintenance.new(start_time: start_time, end_time: end_time) }

  describe '#attributes' do
    it 'Hashを取得する' do
      expect(maintenance.attributes).to eq(
        {
          start_time: Time.zone.parse(start_time).to_s,
          end_time: Time.zone.parse(end_time).to_s,
        })
    end
  end

  describe '#start_time' do
    it 'Timeオブジェクトが返る' do
      expect(maintenance.start_time).to eq(Time.zone.parse(start_time))
      expect(maintenance.start_time).to be_kind_of(Time)
    end
  end

  describe '#end_time' do
    it 'Timeオブジェクトが返る' do
      expect(maintenance.end_time).to eq(Time.zone.parse(end_time))
      expect(maintenance.end_time).to be_kind_of(Time)
    end
  end

  describe '#load' do
    it 'ファイルを読み込んでインスタンス化する' do
      allow(Admin::Maintenance::File).to receive(:read).and_return(maintenance.to_json)
      mock = instance_double(Admin::Maintenance::File)
      allow(Admin::Maintenance::File).to receive(:open).and_return(mock)
      allow(Admin::Maintenance::File).to receive(:exist?).and_return(true)

      expect(Admin::Maintenance.load.attributes).to eq(maintenance.attributes)
    end
  end

  describe '#maintenance?' do
    before do
      travel_to(Time.zone.parse('2020-01-01 00:00:00'))

      mock = instance_double(Admin::Maintenance::File)
      allow(Admin::Maintenance::File).to receive(:open).and_return(mock)
      allow(Admin::Maintenance::File).to receive(:exist?).and_return(true)
    end

    let!(:valid) {
      Admin::Maintenance.new(start_time: '2019-12-31 00:00:00', end_time: '2020-01-01 12:00:00')
    }
    let!(:invalid) {
      Admin::Maintenance.new(start_time: '2019-12-31 00:00:00', end_time: '2019-12-31 23:59:59')
    }

    context '現在時刻がメンテナンスの間' do
      it 'Trueが返る' do
        allow(Admin::Maintenance::File).to receive(:read).and_return(valid.to_json)
        expect(Admin::Maintenance.maintenance?).to be true
      end
    end

    context '現在時刻がメンテナンス外' do
      it 'Falseが返る' do
        allow(Admin::Maintenance::File).to receive(:read).and_return(invalid.to_json)
        expect(Admin::Maintenance.maintenance?).to be false
      end
    end

    context 'メンテナンスのJSONがない場合' do
      it 'Falseが返る' do
        allow(Admin::Maintenance::File).to receive(:exist?).and_return(false)
        expect(Admin::Maintenance.maintenance?).to be false
      end
    end
  end
end
