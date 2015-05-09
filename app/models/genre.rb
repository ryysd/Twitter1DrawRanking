class Genre < ActiveRecord::Base
  def contest_term
    today = Date.today.to_time
    now = Time.now
    one_day_sec = 60 * 60 * 24
    start_time_sec = 60 * 60 * start_time.hour

    today_contest_start_time = today + start_time_sec
    if now < today_contest_start_time
      (today_contest_start_time - one_day_sec)...today_contest_start_time 
    else
      today_contest_start_time...(today_contest_start_time + one_day_sec)
    end
  end
end
