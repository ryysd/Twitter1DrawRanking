class TweetValue < ActiveRecord::Base
  def self.find_latest_value(tweet_id)
    TweetValue.where(tweets_id: tweet_id).order("updated_at DESC").first
  end

  def self.create_from_tweet(tweet)
    TweetValue.create tweets_id: tweet.id,
      favorite_count: tweet.favorite_count,
      retweet_count: tweet.retweet_count,
      reply_count: 0
  end
end
