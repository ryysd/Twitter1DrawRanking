require 'expand_url'

class User < ActiveRecord::Base
  def self.create_from_object(user)
    return if User.exists? user.id

    pixiv_urls = get_pixiv_url_from_object user
    User.create! id: user.id,
      name: user.name,
      icon_url: user.profile_image_url,
      description: user.description,
      followers_count: user.folowers_count,
      follow_count: 0,
      pixiv_url: pixiv_urls.first,
      checked_date: null
  end

  def self.get_pixiv_url_from_object(user)
    urls = user.description_urls.map do |url|
      [url.url, url.display_url, url.expanded_url].map {|u| expand_url u}
    end

    pixiv_urls = urls.flatten.select do |url|
      url.include? 'pixiv'
    end

    pixiv_urls.unique
  end
end
