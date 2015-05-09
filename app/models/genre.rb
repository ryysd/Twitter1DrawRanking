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

  def fetch_query
    term = contest_term
    AuthedTwitter.make_query "##{hash_tag}", since_time: term.begin, until_time: term.end
  end

  def fetch
    (AuthedTwitter.client.search fetch_query, locale: "ja", lang: "ja", result_type: 'recent', include_entity: true).map do |tweet|
      next unless tweet.media?
      next if Tweet.exists? tweet.id

      ActiveRecord::Base.transaction do
        Illust.create_from_tweet_if_not_exists tweet
        TweetValue.create_from_tweet tweet
        User.create_from_tweet_if_not_exists tweet

        Tweet.create id: tweet.id,
          url: tweet.url,
          text: (tweet.text.each_char.select{|c| c.bytes.count < 4 }.join ''),
          users_id: tweet.user.id,
          genres_id: id,
          created_at: tweet.created_at
      end
    end.compact
  end
end
