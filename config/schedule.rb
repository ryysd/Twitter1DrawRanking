require File.expand_path(File.dirname(__FILE__) + "/environment")
set :environment, :development
set :output, '/usr/local/var/log/cron/cron.log'

every :hour do
  rake "one_draw:illust:fetch[2]"
  rake "one_draw:illust:update[1]"
end
