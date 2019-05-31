# frozen_string_literal: true

namespace :maintenance_mode do
  desc 'turn on maintenence mode'
  task start: :environment do
    MaintenanceMode.start
  end

  desc 'turn off maintenence mode'
  task stop: :environment do
    MaintenanceMode.stop
  end
end

class MaintenanceMode
  class << self
    def start
      FileUtils.touch Constants::MAINTENANCE_FILE unless start?
    end

    def start?
      File.exist? Constants::MAINTENANCE_FILE
    end

    def stop
      FileUtils.remove Constants::MAINTENANCE_FILE if start?
    end
  end
end
