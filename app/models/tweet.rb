class Tweet < ActiveRecord::Base
  has_many :illusts
  has_many :tweet_values
  belongs_to :users

  def self.make_fetch_query(keyword, since_time: nil, until_time: nil)
    query = "#{keyword}"
    query += " since:#{since_time.strftime('%Y-%m-%d_%H:%M:%S_JST')}" unless since_time.nil?
    query += " until:#{until_time.strftime('%Y-%m-%d_%H:%M:%S_JST')}" unless until_time.nil?
    query += " -rt"
  end

  def self.make_fetch_query_by_genre(genre)
    keyword = "##{genre.hash_tag}"
    contest_term = genre.contest_term

    AuthedTwitter.make_query keyword, since_time: contest_term.begin, until_time: contest_term.end
  end

  def self.fetch(genre)
    query = Tweet.make_fetch_query_by_genre genre

    (AuthedTwitter.client.search query, locale: "ja", lang: "ja", result_type: 'recent', include_entity: true).map do |tweet|
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
          genres_id: genre.id,
          created_at: tweet.created_at
      end
    end.compact
  end

  def self.update_date(id)
    t =Tweet.find id
    t.touch
    t.save
  end

  def self.value_is_updated?(id, value)
    latest_value = TweetValue.find_latest_value id
    return false unless latest_value.nil?

    return latest_value.favorite_count != value.favorite_count ||
           latest_value.retweet_count != value.retweet_count ||
           latest_value.reply_count != value.reply_count
  end

  def self.update_value_by_tweet(tweet)
    ActiveRecord::Base.transaction do
      Tweet.update_date tweet.id

      TweetValue.create_from_tweet tweet
    end
  end

  def self.update_values(tweet_ids)
    (AuthedTwitter.client.statuses tweet_ids).map do |tweet|
      next unless Tweet.exists? tweet.id

      Tweet.update_value_by_tweet tweet
    end.compact
  end

  def self.update_values_by_updated_at(time_range)
    tweet_ids = ((Tweet.where updated_at: time_range.begin...time_range.end).order 'updated_at ASC').map {|tweet| tweet.id}
    Tweet.update_values tweet_ids unless tweet_ids.nil?
  end
end
