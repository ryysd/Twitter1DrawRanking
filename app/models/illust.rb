class Illust < ActiveRecord::Base
  def self.create_from_objects(medias, tweet_id)
    medias.each do |media|
      next if Illust.exists? media.id

      Illust.create! id: media.id,
        url: media.media_url,
        tweet_id: tweet_id
    end
  end
end
