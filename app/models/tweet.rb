class Tweet < ActiveRecord::Base
  has_many :illusts, dependent: :destroy
  has_many :tweet_values, dependent: :destroy
  belongs_to :users

  def self.create_from_object(tweet, genre_id)
    return if Tweet.exists? tweet.id

    ActiveRecord::Base.transaction do
      Illust.create_from_objects tweet.media, tweet.id
      TweetValue.create_from_object tweet
      User.create_from_object tweet.user

      Tweet.create id: tweet.id,
        url: tweet.url,
        text: (tweet.text.each_char.select{|c| c.bytes.count < 4 }.join ''),
        users_id: tweet.user.id,
        genres_id: genre_id,
        created_at: tweet.created_at
    end
  end

  def self.update(tweet)
    (Tweet.find tweet.id).touch # to be fix
    TweetValue.create_from_object tweet
  end

  def self.update_by_ids(tweet_ids)
    tweets = AuthedTwitter.client.statuses tweet_ids
    tweets.map {|tweet| Tweet.update tweet}.compact
  end

  def self.update_by_period(period)
    tweet_ids = (Tweet.find_by_period period).map {|tweet| tweet.id}
    Tweet.update_by_ids tweet_ids
  end

  def self.find_by_period(period)
    (Tweet.where updated_at: period.begin...period.end).order 'updated_at ASC'
  end
end
