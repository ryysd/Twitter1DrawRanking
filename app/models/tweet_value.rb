class TweetValue < ActiveRecord::Base
  def self.find_latest_value(tweet_id)
    TweetValue.where(tweets_id: tweet_id).order("updated_at DESC").first
  end
end
