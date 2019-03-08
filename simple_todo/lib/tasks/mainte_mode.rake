namespace :mainte_mode do
  desc "maintenance mode start"
  task :start do
    sh 'cp config/maintenance.yml tmp'
  end
  task :end do
    if File.exists? 'tmp/maintenance.yml'
      sh 'rm tmp/maintenance.yml'
    end
  end
end
