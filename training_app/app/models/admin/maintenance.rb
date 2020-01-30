# frozen_string_literal: true

module Admin
  class Maintenance
    class File < ::File
    end

    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModel::AttributeMethods

    MAINTENANCE_JSON = Rails.root.join('config', 'maintenance.json').to_s

    define_attribute_methods :start_time, :end_time
    attr_writer :start_time, :end_time

    validates_each :start_time, :end_time do |record, attr, _|
      v = record.instance_variable_get(:"@#{attr.to_s}")
      if v.present?
        begin
          Time.parse(v)
        rescue ArgumentError
          record.errors.add(attr, I18n.t('errors.messages.invalid_time'))
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
          inst.from_json(File.read(MAINTENANCE_JSON)) if File.exist?(MAINTENANCE_JSON)
        end
    end

    def write
      File.write(MAINTENANCE_JSON, self.to_json)
    end

    def self.maintenance?
      inst = self.load
      Time.zone.now.between?(inst.start_time, inst.end_time)
    end
  end
end
