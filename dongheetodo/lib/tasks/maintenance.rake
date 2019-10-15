namespace :maintenance do
  desc "メンテナンスモードをON・OFFするタスク"

  task :up => :environment do
    env_file = File.join(Rails.root, 'config', 'local_env.yml')
    maintenance = { MAINTENANCE: 'UP' }
    if File.exists?(env_file)
      File.open(env_file, "w") do |file|
        file.write(maintenance.to_yaml)
      end
    end
    YAML.load(File.open(env_file)).each do |k, v|
      p "#{k} : #{v}"
    end
  end

  task :down => :environment do
    env_file = File.join(Rails.root, 'config', 'local_env.yml')
    maintenance = { MAINTENANCE: 'DOWN' }
    if File.exists?(env_file)
      File.open(env_file, "w") do |file|
        file.write(maintenance.to_yaml)
      end
    end
    YAML.load(File.open(env_file)).each do |k, v|
      p "#{k} : #{v}"
    end
  end
end
