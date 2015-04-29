class Tweet < ActiveRecord::Base
  has_many :illusts

  def self.create_by_genre(genre)
    Tweet.client.search("##{genre.hash_tag} -rt", locale: "ja", lang: "ja", result_type: "recent", :include_entity => true).take(10).map do |tweet|
      next if !tweet.media?
      next if Tweet.exists? id: tweet.id

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
        text: tweet.text,
        authors_id: 0,
        genres_id: genre.id,
        created_at: tweet.created_at
    end
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
