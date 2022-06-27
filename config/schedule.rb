# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

def jst(time)
  Time.zone = "Asia/Tokyo"
  Time.zone.parse(time).localtime($system_utc_offset)
end

# every 6.hours do
every 1.day, at: [jst("6:00 am"), jst("6:00 pm"), jst("12:00 am"), jst("12:00 pm"), jst("2:20 pm")] do
  begin
    # bundle exec rake -Tで追加したtaskを確認して貼り付ける
    rake "delete_guest_customer_data:destroy"
  rescue => e
    Rails.logger.error("aborted rails runner")
    raise e
  end
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever