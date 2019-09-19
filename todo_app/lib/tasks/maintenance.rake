# frozen_string_literal: true

namespace :maintenance do
  desc 'enable maintenance'
  task enable: :environment do
    File.write Rails.root.join('tmp', 'maintenance.txt'), ''
  end

  desc 'disable maintenance'
  task disable: :environment do
    File.delete Rails.root.join('tmp', 'maintenance.txt')
  end
end
