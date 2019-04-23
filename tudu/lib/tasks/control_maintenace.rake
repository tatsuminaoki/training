require 'shellwords'

namespace :control_maintenace do
  desc "メンテナンスのオンとオフを制御します"
  task :execute, ['maintenace_mode'] => :environment do |task, args|
    file_path = Rails.root.to_s + '/maintenance.txt'

    if Shellwords.escape(args.maintenace_mode).to_i == 1
      File.open(file_path, 'w') do |file|
        puts 'maintenace off -> on'
      end
    elsif  File.exists?(file_path)
      FileUtils.rm(file_path)
      puts 'maintenace on -> off'
    end
  end
end
