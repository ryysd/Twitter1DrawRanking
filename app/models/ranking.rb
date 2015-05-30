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
  end

  def valid_tweets
    columns = [
      'tweets.id',
      'tweets.text',
      'MAX(tweet_values.favorite_count) AS favorite_count',
      'MAX(tweet_values.retweet_count) AS retweet_count',
      'MAX(tweet_values.favorite_count) + MAX(tweet_values.retweet_count) AS score'
    ]

    conditions = [
      "users.reliability > #{RELIABILITY_THRESHOLD}",
      'tweet_values.favorite_count > tweet_values.retweet_count'
    ]

    tweets
      .select(columns.join ',')
      .joins([:user, :tweet_values])
      .includes(:illusts)
      .where(conditions.join ' AND ')
      .group('tweets.id')
      .order('score DESC')
  end

  def to_json(size: 180)
    tweet_hashes = (valid_tweets.take size).map(&:to_h)

    Jbuilder.encode do |json|
      json.genre genre.name
      json.tweets tweet_hashes
      json.date created_at
    end
  end
end
