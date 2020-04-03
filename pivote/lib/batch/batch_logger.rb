# frozen_string_literal: true

module Batch
  module BatchLogger
    class << self
      delegate(
          :debug,
          :info,
          :warn,
          :error,
          :fatal,
          to: :logger,
      )

      def logger
        @logger ||= begin
          # 標準出力とログファイルの両方に出力する、バッチ用のLoggerオブジェクトを作成
          logger = ActiveSupport::Logger.new(Rails.root.join('log', "batch_#{Rails.env}.log"))
          logger.formatter = Logger::Formatter.new
          logger.datetime_format = '%Y-%m-%d %H:%M:%S'

          stdout_logger = ActiveSupport::Logger.new(STDOUT)
          multiple_loggers = ActiveSupport::Logger.broadcast(stdout_logger)
          logger.extend(multiple_loggers)

          logger
        end
      end
    end
  end
end
