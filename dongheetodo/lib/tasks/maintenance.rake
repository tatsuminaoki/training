namespace :maintenance do
  desc "メンテナンスモードをON・OFFするタスク"

  task :up => :environment do
    change_mode('UP')
  end

  task :down => :environment do
    change_mode('DOWN')
  end

  private

  def change_mode(option)
    maintenance = { MAINTENANCE: option }
    file = read_local_env
    File.open(file, "w") do |f|
      f.write(maintenance.to_yaml)
    end
    print_local_env
  end

  def read_local_env
    File.join(Rails.root, 'config', 'local_env.yml')
  end

  def print_local_env
    file = read_local_env
    p '以下のように切り替えました。'
    YAML.load(File.open(file)).each do |k, v|
      p "#{k} : #{v}"
    end
  end
end
