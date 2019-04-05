namespace :maintenance do

  desc 'メンテナンススタート'
  task start: :environment do
    # maintenances_enum 作成　
    Maintenance.create!(maintenance_enum: 1)
  end

  desc 'メンテナンス終了'
  task finish: :environment do
    # maintenances_enum 作成　
    Maintenance.create!(maintenance_enum: 0)
  end
end
