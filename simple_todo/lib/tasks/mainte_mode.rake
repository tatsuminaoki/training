namespace :mainte_mode do
  desc "to start maintenance mode"
  task :start do
    sh 'cp config/maintenance.yml tmp'
  end
  desc "to finish maintenance mode"
  task :end do
    if File.exists? 'tmp/maintenance.yml'
      sh 'rm tmp/maintenance.yml'
    end
  end
end
