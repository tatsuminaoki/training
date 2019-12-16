namespace :maintenance do
  desc "set maintenance_mode on"
  task :on do
    ENV['MAINTENANCE_MODE'] = "on"
  end

  desc "set maintenance_mode off"
  task :off do
    ENV['MAINTENANCE_MODE'] = "off"
  end
end
