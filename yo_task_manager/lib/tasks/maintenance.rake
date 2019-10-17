namespace :maintenance do
  desc "start maintenance mode, usage: rake maintenance:start[{reason}]"
  task :start, [:reason] do |t, args|
    reason = args[:reason]
    reason = 'no reason provided.' if reason.blank?
    FileUtils.mkdir('tmp') unless Dir.exists?('tmp')
    unless File.exists?('tmp/maintenance.yml')
      File.open('tmp/maintenance.yml', 'w+') do |f|
        f.write("reason: #{reason}")
      end
    end
  end

  desc "stop maintenance mode"
  task :stop do
    if File.exists?('tmp/maintenance.yml')
      File.delete('tmp/maintenance.yml')
    end
  end
end
