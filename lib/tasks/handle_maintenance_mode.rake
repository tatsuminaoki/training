namespace :handle_maintenance_mode do
  desc 'メンテナンスモードに入る'
  task :start do
    sh 'cp config/maintenance.yml tmp/maintenance.yml'
    p 'メンテナンスモードに入りました'
  end

  desc 'メンテナンスモードを終了する'
  task :end do
    if File.exists? 'tmp/maintenance.yml'
      sh 'rm tmp/maintenance.yml'
      p 'メンテナンスモードを終了しました'
    else
      p 'メンテナンスモードではありません'
    end
  end
end
