# frozen_string_literal: true

require "#{Rails.root}/app/models/logic_maintenance"

namespace :maintenance do
  desc 'Maintenance register ex: rake maintenance:register["2020-01-01 00","2020-01-01 01"] .'
  task :register, %w[start end] => :environment do |_task, args|
    if LogicMaintenance.register(args[:start], args[:end])
      p 'Success.'
    else
      p 'Fail.'
    end
  end

  desc 'Maintenance stop ex: rake maintenance:stop .'
  task stop: :environment do
    if LogicMaintenance.register(Time.now.ago(2.days).to_s, Time.now.ago(1.day).to_s)
      p 'Success.'
    else
      p 'Fail.'
    end
  end
end
