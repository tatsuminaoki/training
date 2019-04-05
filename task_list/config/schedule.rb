# Learn more: http://github.com/javan/whenever
# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"
set :path, '/Users/yui.yoshida/training/task_list'

every 1.day, at: ['1:00 am'] do
  rake 'maintenance:start'
end

every 1.day, at: ['2:00 am'] do
  rake 'maintenance:finish'
end