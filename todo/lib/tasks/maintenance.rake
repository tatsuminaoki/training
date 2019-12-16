# frozen_string_literal: true

namespace :maintenance do
  desc 'set maintenance_mode on'
  task on: :environment do
    setting = SiteSetting.first_or_create
    setting.update(maintenance: :on)
  end

  desc 'set maintenance_mode off'
  task off: :environment do
    setting = SiteSetting.first_or_create
    setting.update(maintenance: :off)
  end
end
