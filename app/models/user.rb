require 'media_url'
require 'retriable'

class User < ActiveRecord::Base
  extend Retriable
  include Retriable

  def self.create_from_object(user)
    return if User.exists? user.id

    pixiv_id = get_pixiv_id_from_object user

    User.create! id: user.id,
      name: user.name,
      icon_url: user.profile_image_url,
      description: user.description,
      followers_count: user.followers_count,
      follow_count: user.friends_count,
      pixiv_id: pixiv_id,
      tumblr_id: nil,
      status_id: 0
  end

  def create_following_users
    following_user_ids = do_retriable { AuthedTwitter.client.friend_ids id }
    sliced_ids = following_user_ids.each_slice(100).to_a

    sliced_ids.each do |ids|
      do_retriable { (AuthedTwitter.client.friends ids).each { |u| User.create_from_object u } }
    end
  end

  def self.update_follow_count(users)
    ids = users.map(&:id)
    do_retriable { AuthedTwitter.client.users ids }.each do |user|
      (User.find_by_id user.id).update_attributes follow_count: user.friends_count
    end
  end

  def self.update_pixiv_id_by_objects(users)
    ids = users.map(&:id)
    do_retriable { AuthedTwitter.client.users ids }.each do |user|
      (User.find_by_id user.id).update_pixiv_id_by_object user
    end
  end

  def update_pixiv_id_by_object(user)
    pixiv_id = User.get_pixiv_id_from_object user
    update_attributes pixiv_id: pixiv_id unless pixiv_id.nil?
  end

  def update_reliability
    update_attributes reliability: calc_reliability
  end

  def update_follow_count
    user = (do_retriable { AuthedTwitter.client.users id }).first
    update_attributes follow_count user.friends_count
  end

  def calc_reliability
    return 100 unless pixiv_id.nil?
    return 60 if maybe_illustrator?
    0
    # following_user_ids = do_retriable { AuthedTwitter.client.friend_ids id }
    # return 0 if following_user_ids.to_a.empty?

    # calc_known_unknown_ratio following_user_ids
  end

  def maybe_illustrator?
    condition1 = /(イラスト|漫画|絵|マンガ|挿絵).*(描|書|か)(い|き|く)/.match description
    condition2 = /(キャラデザ|キャラクターデザイン|原画)/.match description
    condition3 = /(イラストレータ|アニメータ|漫画家|マンガ家|マンガ屋|漫画屋|絵師|原画家|アニメ屋|連載)/.match description
    negative_condition1 = /(bot|フォロー用)/.match description
    negative_condition2 = /(運営|公式|開発)/.match name

    (!condition1.nil? || !condition2.nil? || !condition3.nil?) && negative_condition1.nil? && negative_condition2.nil?
  end

  def calc_known_unknown_ratio(following_user_ids)
    known_users = User.where id: following_user_ids.to_a

    known_users.size * 100 / following_user_ids.to_a.size
  end

  def self.get_pixiv_id_from_object(user)
    urls = get_urls_from_object user
    (MediaUrl.get_pixiv_id_from_urls urls) || (MediaUrl.get_pixiv_id_from_description user.description)
  end

  def self.get_urls_from_object(user)
    desc_urls = user.description_urls.map {|url| url.expanded_url}
    web_urls = user.website_urls.map {|url| url.expanded_url}

    (desc_urls + web_urls).map(&:to_s).map do |url| 
      (MediaUrl.short_url? url) ? (MediaUrl.expand_url url) : url
    end.flatten.uniq
  end
end
