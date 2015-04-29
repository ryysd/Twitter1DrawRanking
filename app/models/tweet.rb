class Tweet < ActiveRecord::Base
  has_many :illusts

  def self.create_by_genre(genre)
    Tweet.client.search("##{genre.hash_tag} -rt", locale: "ja", lang: "ja", result_type: "recent", :include_entity => true).map do |tweet|
      next if !tweet.media?
      next if Tweet.exists? id: tweet.id

      tweet.media.map do |media|
        Illust.create url: media.media_url,
          tweets_id: tweet.id
      end

      Tweet.create id: tweet.id,
        url: tweet.url,
        favorite_count: tweet.favorite_count,
        retweet_count: tweet.retweet_count,
        reply_count: 0,
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
