class Tweet < ActiveRecord::Base
  has_many :illusts
  has_many :tweet_values
  belongs_to :users

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
