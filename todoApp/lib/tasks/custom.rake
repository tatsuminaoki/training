namespace :maintenance do
  desc "Maintenance Mode On"
  task init: :environment do
    puts 'initialize maintenance data..'
    Maintenance.delete_all
    Maintenance.create!(name: 'example maintenance', maintenance_mode: 0)
  end

  desc "Maintenance Mode On"
  task start: :environment do
    puts 'maintenance start!'
    Maintenance.first.update!(maintenance_mode: true)
  end

  desc "Maintenance Mode Off"
  task end: :environment do
    if Maintenance.first.presence
      puts 'maintenance end!'
      Maintenance.first.update!(maintenance_mode: false)
    else
      puts 'nothing to do!'
    end
  end

  task start: :init
end
