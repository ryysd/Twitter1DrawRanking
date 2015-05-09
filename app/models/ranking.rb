class Ranking < ActiveRecord::Base
  has_many :tweet_rankings
  has_many :tweets, through: :tweet_rankings

  def self.create_daily(genre, date)
    term = genre.contest_term date
    target_tweets = Tweet.by_created_at term
    ranking_type = RankingType.daily

    Ranking.create ranking_type_id: ranking_type.id,
      genre_id: genre.id,
      tweets: target_tweets
  end

  def to_json
    tweets.map do |tweet|
      tweet.tweet_values
    end
  end
end
