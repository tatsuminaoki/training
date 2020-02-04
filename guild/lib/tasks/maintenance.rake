require "#{Rails.root}/app/models/logic_maintenance"

namespace :maintenance do
  desc 'Maintenance register'
  task :register, ['start', 'end'] => :environment do |task, args|
    if LogicMaintenance.register(args[:start], args[:end])
      p 'Success.'
    else
      p 'Fail.'
    end
  end

  desc 'Maintenance stop'
  task stop: :environment do
    if LogicMaintenance.register(Time.now.ago(2.days).to_s, Time.now.ago(1.days).to_s)
      p 'Success.'
    else
      p 'Fail.'
    end
  end
end
