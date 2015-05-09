require File.expand_path(File.dirname(__FILE__) + "/environment")
set :environment, :development
set :output, '/usr/local/var/log/cron/cron.log'

every :hour do
  rake "one_draw:illust:update_and_fetch"
end
