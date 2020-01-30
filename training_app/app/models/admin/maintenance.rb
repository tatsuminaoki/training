# frozen_string_literal: true

module Admin
  class Maintenance
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModel::AttributeMethods

    MAINTENANCE_JSON = Rails.root.join('config', 'maintenance.json')

    define_attribute_methods :start_time, :end_time
    attr_writer :start_time, :end_time

    validates_each :start_time, :end_time do |record, attr, value|
      if value.present?
        begin
          Time.zone.parse(value)
        rescue ArgumentError
          record.errors.add(attr, 'invalid time.')
        end
      end
    end

    def attributes
      {
        start_time: self.start_time.to_s,
        end_time: self.end_time.to_s,
      }
    end

    def start_time
      Time.zone.parse(@start_time || '2000-01-01 00:00:00')
    end

    def end_time
      Time.zone.parse(@end_time || '2999-12-31 23:59:59')
    end

    def self.load
      self
        .new
        .tap do |inst|
          inst.from_json(MAINTENANCE_JSON.read) if MAINTENANCE_JSON.exist?
        end
    end

    def self.maintenance?
      inst = self.load
      Time.zone.now.between?(inst.start_time, inst.end_time)
    end
  end
end
