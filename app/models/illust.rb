class Illust < ActiveRecord::Base
  def self.create_from_tweet_if_not_exists(tweet)
    tweet.media.each do |media|
      next if Illust.exists? media.id

      Illust.create id: media.id,
        url: media.media_url,
        tweets_id: tweet.id
    end
  end
end
