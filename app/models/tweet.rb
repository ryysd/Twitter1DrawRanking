class Tweet < ActiveRecord::Base
  has_many :illusts
  has_many :tweet_values
  belongs_to :users

  def self.create_unless_exists(tweet, genre_id)
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

  def self.update_date(id)
    t =Tweet.find id
    t.touch
    t.save
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
