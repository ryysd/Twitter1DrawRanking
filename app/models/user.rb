require 'media_url'

class User < ActiveRecord::Base
  def self.create_from_object(user)
    return if User.exists? user.id

    urls = get_urls_from_object user
    pixiv_id = (MediaUrl.get_pixiv_id_from_urls urls) || (MediaUrl.get_pixiv_id_from_description user.description)
    tumblr_id = MediaUrl.get_tumblr_id_from_urls urls

    User.create! id: user.id,
      name: user.name,
      icon_url: user.profile_image_url,
      description: user.description,
      followers_count: user.followers_count,
      follow_count: 0,
      pixiv_id: pixiv_id,
      tumblr_id: tumblr_id,
      checked_date: nil
  end

  def self.create_following_users(user)
    following_user_ids = AuthedTwitter.client.friend_ids user.id
    following_user_ids.each_slice(100).to_a

    following_user_ids.each do |ids|
      begin
        (AuthedTwitter.client.friends ids).each {|user| User.create_from_object user}
      rescue Twitter::Error::TooManyRequests => e
        pp "sleep #{e.rate_limit.reset_in + 1} sec"
        sleep e.rate_limit.reset_in + 1
        retry
      end
    end
  end

  def self.get_urls_from_object(user)
    desc_urls = user.description_urls.map {|url| url.expanded_url}
    web_urls = user.website_urls.map {|url| url.expanded_url}

    (desc_urls + web_urls).map(&:to_s).map do |url| 
      (MediaUrl.is_short_url url) ? (MediaUrl.expand_url url) : url
    end.flatten.uniq
  end
end
