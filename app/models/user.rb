require 'media_url'
require 'retriable'

class User < ActiveRecord::Base
  extend Retriable
  include Retriable

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
    following_user_ids = do_retriable { AuthedTwitter.client.friend_ids user.id }
    sliced_ids = following_user_ids.each_slice(100).to_a

    sliced_ids.each do |ids|
      do_retriable { (AuthedTwitter.client.friends ids).each { |u| User.create_from_object u } }
    end
  end

  def update_pixiv_id_by_object(user)
    urls = User.get_urls_from_object user
    pixiv_id = (MediaUrl.get_pixiv_id_from_urls urls) || (MediaUrl.get_pixiv_id_from_description user.description)

    update_attributes pixiv_id: pixiv_id unless pixiv_id.nil?
  end

  def update_reliability
    following_user_ids = do_retriable { AuthedTwitter.client.friend_ids id }

    update_attributes follow_count: following_user_ids.to_a.size,
      reliability: (calc_reliability following_user_ids)
  end

  def calc_reliability(following_user_ids)
    return 100 unless pixiv_id.nil?
    base =  !tumblr_id.nil? ? 50 : 0

    rel = base + (calc_known_unknown_ratio following_user_ids)

    rel < 100 ? rel : 100
  end

  def calc_known_unknown_ratio(following_user_ids)
    known_users = User.where id: following_user_ids.to_a

    pp known_users.to_a.size
    pp following_user_ids.to_a.size
    known_users.size * 100 / following_user_ids.to_a.size
  end

  def self.get_urls_from_object(user)
    desc_urls = user.description_urls.map {|url| url.expanded_url}
    web_urls = user.website_urls.map {|url| url.expanded_url}

    (desc_urls + web_urls).map(&:to_s).map do |url| 
      (MediaUrl.short_url? url) ? (MediaUrl.expand_url url) : url
    end.flatten.uniq
  end
end
