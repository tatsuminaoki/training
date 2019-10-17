# frozen_string_literal: true

namespace :maintenance do
  desc 'start maintenance mode, usage: rake maintenance:start[{reason}]'
  task :start, [:reason] do |_t, args|
    reason = args[:reason]
    reason = 'no reason provided.' if reason.blank?
    FileUtils.mkdir('tmp') unless Dir.exist?('tmp')
    unless File.exist?('tmp/maintenance.yml')
      File.open('tmp/maintenance.yml', 'w+') do |f|
        f.write("reason: #{reason}")
      end
    end
  end

  desc 'stop maintenance mode'
  task :stop do
    File.delete('tmp/maintenance.yml') if File.exist?('tmp/maintenance.yml')
  end
end
