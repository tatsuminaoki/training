# frozen_string_literal: true

namespace :maintenance do
  desc 'start maintenance mode, usage: rake maintenance:start[{period}]'
  task :start, [:period] do |_, args|
    period = args[:period]
    FileUtils.mkdir('tmp') unless Dir.exist?('tmp')
    File.open('tmp/maintenance.yml', 'w') { |f| f.write("period: #{period}") } unless File.exist?('tmp/maintenance.yml')
  end

  desc 'update maintenance comment, usage: rake maintenance:update[{period}]'
  task :update, [:period] do |_, args|
    period = args[:period]
    File.open('tmp/maintenance.yml', 'w') { |f| f.write("period: #{period}") } if File.exist?('tmp/maintenance.yml')
  end

  desc 'stop maintenance mode'
  task :stop do
    FileUtils.rm('tmp/maintenance.yml') if File.exist?('tmp/maintenance.yml')
  end
end
