# frozen_string_literal: true

namespace :maintenance_mode do
  desc 'メンテナンス開始'
  task :start do
    if File.exist? 'tmp/maintenance.yml'
      puts 'メンテナンスモードです'
    else
      sh 'cp config/maintenance.yml tmp/maintenance.yml'
      puts 'メンテナンスモードに入りました'
    end
  end

  desc 'メンテナンス終了'
  task :end do
    if File.exist? 'tmp/maintenance.yml'
      sh 'rm tmp/maintenance.yml'
      puts 'メンテナンスモードを終了しました'
    else
      puts 'メンテナンスモードではありません'
    end
  end
end
