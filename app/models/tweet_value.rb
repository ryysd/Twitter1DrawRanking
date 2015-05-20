# Tweet Value Model
class TweetValue < ActiveRecord::Base
  belongs_to :tweet, touch: true
  scope :by_tweet_id, ->(tweet_id) { where(tweet_id: tweet_id) }
  scope :by_updated_at, ->(updated_at) { where(updated_at: updated_at) }
  scope :by_created_at, ->(created_at) { where(created_at: created_at) }
  scope :recent, -> { order('updated_at DESC') }

  def self.latest(tweet_id)
    TweetValue.by_tweet_id(tweet_id).recent.first
  end

  def self.find_by_updated_at(tweet_id, updated_at)
    TweetValue.by_tweet_id(tweet_id).by_updated_at(updated_at)
  end

  def self.find_by_created_at(tweet_id, created_at)
    TweetValue.by_tweet_id(tweet_id).by_created_at(created_at)
  end

  def self.create_from_object(tweet)
    TweetValue.create! tweet_id: tweet.id,
      favorite_count: tweet.favorite_count,
      retweet_count: tweet.retweet_count,
      reply_count: 0
  end

  def score
    favorite_count * 2 + retweet_count
  end
end
