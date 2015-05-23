require 'zlib'

class Ranking < ActiveRecord::Base
  belongs_to :genre
  has_many :tweet_rankings
  has_many :tweets, through: :tweet_rankings

  MAX_TWEET_NUM = 100
  RELIABILITY_THRESHOLD = 20

  scope :by_created_at, ->(created_at) {where(created_at: created_at)}
  scope :by_genre_id, ->(genre_id) {where(genre_id: genre_id)}

  def self.create_daily(genre, date)
    term = genre.contest_term date
    target_tweets = (Tweet.by_created_at term).by_genre_id genre.id
    ranking_type = RankingType.daily

    ranking = Ranking.create ranking_type_id: ranking_type.id,
      genre_id: genre.id,
      tweets: target_tweets,
      created_at: date

    ranking.update_cache

    ranking
  end

  def update_cache
    compressed_json = Zlib::Deflate.deflate to_json
    update_attributes cache: compressed_json
  end

  def json_cache
    return nil if cache.nil?
    Zlib::Inflate.inflate cache
  end

  def valid_tweets
    tweets
      .joins(:user)
      .joins(:tweet_values)
      .eager_load(:tweet_values)
      .where("users.reliability > #{RELIABILITY_THRESHOLD} AND tweet_values.favorite_count > tweet_values.retweet_count")
      .order('tweet_values.updated_at')
      .uniq { |tweet| tweet.id }
  end

  def to_json(use_cache: false)
    if use_cache
      update_cache if json_cache.nil?
      return json_cache
    end

    tweet_hashes = (valid_tweets.includes [:illusts]).map(&:to_h)

    Jbuilder.encode do |json|
      json.genre genre.name
      json.tweets tweet_hashes
      json.date created_at
    end
  end
end
