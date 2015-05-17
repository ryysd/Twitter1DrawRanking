class Ranking < ActiveRecord::Base
  belongs_to :genre
  has_many :tweet_rankings
  has_many :tweets, through: :tweet_rankings

  scope :by_created_at, ->(created_at) {where(created_at: created_at)}
  scope :by_genre_id, ->(genre_id) {where(genre_id: genre_id)}

  def self.create_daily(genre, date)
    term = genre.contest_term date
    target_tweets = (Tweet.by_created_at term).by_genre_id genre.id
    ranking_type = RankingType.daily

    Ranking.create ranking_type_id: ranking_type.id,
      genre_id: genre.id,
      tweets: target_tweets,
      created_at: date
  end

  def to_json
    tweet_hashes = (tweets.includes :illusts).map {|tweet| tweet.to_h}

    Jbuilder.encode do |json|
      json.genre genre.name
      json.tweets tweet_hashes
      json.date created_at
    end
  end
end
