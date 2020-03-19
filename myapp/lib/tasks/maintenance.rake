namespace :maintenance do
  task start: :environment do
    puts 'maintenance start'
    data = { 'maintenance_mode' => true }
    File.open('config/maintenance.yml', 'w') { |f| YAML.dump(data, f) }
  end

  task end: :environment do
    puts 'maintenance end'
    data = { 'maintenance_mode' => false }
    File.open('config/maintenance.yml', 'w') { |f| YAML.dump(data, f) }
  end
end
