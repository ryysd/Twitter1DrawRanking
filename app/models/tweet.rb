class Tweet < ActiveRecord::Base
  has_many :illusts, dependent: :destroy
  has_many :tweet_values, dependent: :destroy
  has_many :tweet_rankings
  belongs_to :users

  scope :by_updated_at, ->(updated_at) {where(updated_at: updated_at)}
  scope :by_created_at, ->(created_at) {where(created_at: created_at)}
  scope :recent, -> {order('updated_at DESC')}
  scope :older, -> {order('updated_at ASC')}

  def self.fetch(genre)
    term = genre.contest_term_now
    query = AuthedTwitter.make_query "##{genre.hash_tag}", since_time: term.begin, until_time: term.end

    (AuthedTwitter.client.search query, locale: "ja", lang: "ja", result_type: 'recent', include_entity: true).map do |tweet|
      next unless tweet.media?
      Tweet.create_from_object tweet, genre.id
    end.compact
  end

  def self.create_from_object(tweet, genre_id)
    return if Tweet.exists? tweet.id

    ActiveRecord::Base.transaction do
      Illust.create_from_objects tweet.media, tweet.id
      TweetValue.create_from_object tweet
      User.create_from_object tweet.user

      Tweet.create id: tweet.id,
        url: tweet.url,
        text: (tweet.text.each_char.select{|c| c.bytes.count < 4 }.join ''),
        user_id: tweet.user.id,
        genre_id: genre_id,
        created_at: tweet.created_at
    end
  end

  def self.update_by_ids(tweet_ids)
    tweets = AuthedTwitter.client.statuses tweet_ids
    tweets.map {|tweet| TweetValue.create_from_object tweet}.compact
  end

  def self.update_by_period(period)
    tweet_ids = (Tweet.by_updated_at period).older.map {|tweet| tweet.id}
    Tweet.update_by_ids tweet_ids
  end
end
