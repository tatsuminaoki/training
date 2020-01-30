# frozen_string_literal: true

def console(msg)
  puts msg unless Rails.env.test?
end

namespace :maintenance do
  desc 'メンテにする'
  task :start, ['end'] => :environment do |_, args|
    maintenace = Admin::Maintenance
      .new
      .tap { |inst| inst.end_time = args[:end] }

    unless maintenace.valid?
      console maintenace.errors.full_messages
      next
    end

    console "#{args[:end]}までメンテです"
    maintenace.write
  end

  desc 'メンテやめる'
  task stop: :environment do
    maintenance = Admin::Maintenance
      .new
      .tap { |inst| inst.end_time = Time.zone.now.ago(1.second).to_s }

    unless maintenance.valid?
      console(maintenace.errors.full_messages)
      next
    end

    console 'メンテ終了しました'
    maintenance.write
  end
end
