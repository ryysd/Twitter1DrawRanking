class Genre < ActiveRecord::Base
  def self.find_by_hash_tags(hash_tags)
    hash_tags.map {|hash_tag| Genre.find_by_hash_tag hash_tag.text}.compact.first
  end

  def contest_start_time(date)
    date.to_time + (60 * 60 * start_time.hour)
  end

  def contest_term_now
    one_day_sec = 60 * 60 * 24
    today_contest_start_time = contest_start_time Date.today

    if Time.now < today_contest_start_time
      (today_contest_start_time - one_day_sec)...today_contest_start_time 
    else
      today_contest_start_time...(today_contest_start_time + one_day_sec)
    end
  end

  def contest_term(date)
    one_day_sec = 60 * 60 * 24
    date_contest_start_time = date.to_time + (60 * 60 * start_time.hour)
    date_contest_start_time...(date_contest_start_time + one_day_sec)
  end
end
