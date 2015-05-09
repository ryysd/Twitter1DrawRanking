class Genre < ActiveRecord::Base
  def contest_term
    one_day_sec = 60 * 60 * 24
    today_contest_start_time = Date.today.to_time + (60 * 60 * start_time.hour)

    if Time.now < today_contest_start_time
      (today_contest_start_time - one_day_sec)...today_contest_start_time 
    else
      today_contest_start_time...(today_contest_start_time + one_day_sec)
    end
  end

  def query
    term = contest_term
    AuthedTwitter.make_query "##{hash_tag}", since_time: term.begin, until_time: term.end
  end

  def fetch
    (AuthedTwitter.client.search query, locale: "ja", lang: "ja", result_type: 'recent', include_entity: true).map do |tweet|
      next unless tweet.media?
      Tweet.create_unless_exists tweet, id
    end.compact
  end
end
