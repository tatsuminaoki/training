namespace :maintenance do
  desc "Maintenance Mode On"
  task init: :environment do
    puts 'initialize maintenance data..'
    Maintenance.delete_all
    Maintenance.create!(maintenance_mode: 0)
  end

  desc "Maintenance Mode On"
  task start: :environment do
    puts 'maintenance start!'
    Maintenance.last.update!(maintenance_mode: true)
  end

  desc "Maintenance Mode Off"
  task end: :environment do
    unless Maintenance.count <= 0
      puts 'maintenance end!'
      Maintenance.last.update!(maintenance_mode: false)
    else
      puts 'nothing to do!'
    end
  end

  task start: :init
end
