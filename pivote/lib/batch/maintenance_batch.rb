# frozen_string_literal: true

module Batch
  class MaintenanceBatch
    def self.start
      return BatchLogger.error('既にメンテナンス中です。') if File.exist?(MAINTENANCE_FILE_PATH)

      data = { start_time: Time.current }
      YAML.dump(data, File.open(MAINTENANCE_FILE_PATH, 'w'))
    end

    def self.end
      return BatchLogger.error('メンテナンス中ではありません。') unless File.exist?(MAINTENANCE_FILE_PATH)

      FileUtils.rm(MAINTENANCE_FILE_PATH)
    end
  end
end
