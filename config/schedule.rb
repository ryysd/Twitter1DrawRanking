require File.expand_path(File.dirname(__FILE__) + "/environment")
set :environment, :development
set :output, '/usr/local/var/log/cron/cron.log'

every 3.minute do
  # rake "one_draw:illust:fetch"
  # rake "one_draw:illust:update"
end
