require "#{Rails.root}/app/models/logic_maintenance"

namespace :maintenance do
  desc 'Maintenance register'
  task :register, ['start', 'end'] => :environment do |task, args|
    p 'Fail.' unless LogicMaintenance.register(args[:start], args[:end])
    p 'Success.'
  end

  desc 'Maintenance stop'
  task stop: :environment do
    p 'Fail.' unless LogicMaintenance.register(Time.now.ago(2.days).to_s, Time.now.ago(1.days).to_s)
    p 'Success.'
  end
end
