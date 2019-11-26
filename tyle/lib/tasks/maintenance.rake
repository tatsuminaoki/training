# frozen_string_literal: true

# When 'tmp/maintenance.yml' exists, the maintenance mode is running.
# When not, the maintenance mode is NOT running.
namespace :maintenance do
  desc 'start maintenance mode, usage: rake maintenance:start[{period}]'
  task :start, [:period] do |_, args|
    if File.exist?('tmp/maintenance.yml')
      STDERR.puts "ERROR!\nThe maintenance mode has already started."
      exit 1
    end

    period = args[:period]
    unless period
      STDERR.puts "ERROR!\nThe maintenance failed to start. Input the maintenance period. Usage: $ rake maintenance:start[period]"
      exit 1
    end

    FileUtils.mkdir('tmp') unless Dir.exist?('tmp')
    File.open('tmp/maintenance.yml', 'w') { |f| f.write("period: #{period}") }
    puts "SUCCESS!\nYou have successfuly started the maintenance mode; period: #{period}"
  end

  desc 'update maintenance comment, usage: rake maintenance:update[{period}]'
  task :update, [:period] do |_, args|
    unless File.exist?('tmp/maintenance.yml')
      STDERR.puts "ERROR!\nThe maintenance mode is not running."
      exit 1
    end

    period = args[:period]
    unless period
      STDERR.puts "ERROR!\nThe maintenance failed to be updated. Input the maintenance period. Usage: $ rake maintenance:update[period]"
      exit 1
    end

    File.open('tmp/maintenance.yml', 'w') { |f| f.write("period: #{period}") }
    puts "SUCCESS!\nYou have successfuly updated the maintenance mode; period: #{period}"
  end

  desc 'stop maintenance mode'
  task :stop do
    unless File.exist?('tmp/maintenance.yml')
      STDERR.puts "ERROR!\nThe maintenance mode has already stopped."
      exit 1
    end

    FileUtils.rm('tmp/maintenance.yml')
    puts "SUCCESS!\nYou have successfully stopped the maintenance mode."
  end
end
