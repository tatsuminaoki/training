namespace :maintenance do

  desc 'メンテナンススタート'
  task start: :environment do
    # is_maintenance 作成　
    Maintenance.create!(is_maintenance: 1)
  end

  desc 'メンテナンス終了'
  task finish: :environment do
    # is_maintenance 更新　
    Maintenance.last.update!(is_maintenance: 0)
  end
end
