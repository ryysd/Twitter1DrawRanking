class Tweet < ActiveRecord::Base
  has_many :illusts
  has_many :tweet_values

  def self.create_by_genre(genre)
    (Tweet.client.search "##{genre.hash_tag} -rt", locale: "ja", lang: "ja", result_type: "recent", :include_entity => true).map do |tweet|
      next unless tweet.media?
      next if Tweet.exists? id: tweet.id

      ActiveRecord::Base.transaction do
        tweet.media.each do |media|
          next if Illust.exists? media.id

          Illust.create id: media.id,
            url: media.media_url,
            tweets_id: tweet.id
        end

        TweetValue.create tweets_id: tweet.id,
          favorite_count: tweet.favorite_count,
          retweet_count: tweet.retweet_count,
          reply_count: 0

        Tweet.create id: tweet.id,
          url: tweet.url,
          text: (tweet.text.each_char.select{|c| c.bytes.count < 4 }.join ''),
          authors_id: tweet.user.id,
          genres_id: genre.id,
          created_at: tweet.created_at
      end
    end
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

      TweetValue.create tweets_id: tweet.id,
        favorite_count: tweet.favorite_count,
        retweet_count: tweet.retweet_count,
        reply_count: 0
    end
  end

  def self.update_values(tweet_ids)
    (Tweet.client.statuses tweet_ids).each do |tweet|
      next unless Tweet.exists? id: tweet.id

      Tweet.update_value_by_tweet tweet
    end
  end

  def self.update_values_by_updated_at(time_range)
    tweet_ids = ((Tweet.where updated_at: time_range.begin...time_range.end).order 'updated_at ASC').map {|tweet| tweet.id}
    Tweet.update_values tweet_ids unless tweet_ids.nil?
  end

  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end
  end
end
