require 'expand_url'

class User < ActiveRecord::Base
  def self.create_from_object(user)
    return if User.exists? user.id

    pixiv_ids = get_pixiv_ids_from_object user
    User.create! id: user.id,
      name: user.name,
      icon_url: user.profile_image_url,
      description: user.description,
      followers_count: user.followers_count,
      follow_count: 0,
      pixiv_id: pixiv_ids.first,
      checked_date: nil
  end

  def self.get_pixiv_ids_from_object(user)
    (get_pixiv_url_from_object user).map {|url| get_pixiv_id_from_url url}.uniq
  end

  def self.get_pixiv_url_from_object(user)
    urls = user.description_urls.map do |url|
      [url.url, url.expanded_url].map {|u| expand_url u.to_s}
    end

    p urls
    pixiv_urls = urls.flatten.select do |url|
      url.include? 'pixiv'
    end

    pixiv_urls.uniq
  end

  def self.get_pixiv_id_from_url(pixiv_url)
    reg = /https?:\/\/www.pixiv.net\/member\.php\?id=(?<id>[0-9]+)/
    result = reg.match pixiv_url

    result[:id] unless result.nil?
  end
end
