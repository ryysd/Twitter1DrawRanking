# Tweet Model
class Tweet < ActiveRecord::Base
  has_many :illusts, dependent: :destroy
  has_many :tweet_values, dependent: :destroy
  has_many :tweet_rankings
  belongs_to :users

  UPDATE_INTERVAL_MINUTE = 15
  UPDATE_INTERVAL_SEC = UPDATE_INTERVAL_MINUTE * 60

  scope :by_genre_id, ->(genre_id) { where(genre_id: genre_id) }
  scope :by_updated_at, ->(updated_at) { where(updated_at: updated_at) }
  scope :by_created_at, ->(created_at) { where(created_at: created_at) }
  scope :recent, -> { order('updated_at DESC') }
  scope :older, -> { order('updated_at ASC') }

  # 指定したカテゴリの画像付ツイートを取得
  # @param [Genre] カテゴリ
  def self.fetch(genre)
    term = genre.contest_term_now
    query = AuthedTwitter.make_query "##{genre.hash_tag}", since_time: term.begin, until_time: term.end

    (AuthedTwitter.client.search query, locale: 'ja', lang: 'ja', result_type: 'recent', include_entity: true).map do |tweet|
      next unless tweet.media?
      Tweet.create_from_object tweet, genre.id
    end.compact
  end

  # 指定したユーザの画像付ツイートをstreamで取得
  # @param [Array<Twitter::User>] 対象ユーザ
  def self.fetch_by_stream(target_users)
    AuthedTwitter.streaming_client.filter(follow: target_users) do |tweet|
      next if valid_media? tweet

      genre = (Genre.find_by_hash_tags tweet.hashtags) || (Genre.find_by_alias 'original')

      origin_tweet = tweet.retweet? ? tweet.retweeted_status : tweet
      next if update_if_already_exist origin_tweet

      begin
        create_from_object_with_user origin_tweet, genre.id
      rescue => e
        logger.error e
      end
    end
  end

  # 指定したTwitter::Tweetオブジェクトが画像を持っているかを確認
  def self.valid_media?(tweet)
    (tweet.instance_of? Twitter::Tweet) && tweet.media?
  end

  # 指定したツイートが既に存在するかを確認し、存在する場合は更新する
  # ただし、UPDATE_INTERVAL_MINUTE分以内に更新されている場合は更新を行わない
  def self.update_if_already_exist(tweet)
    existing_tweet = Tweet.find_by_id origin_tweet.id

    is_exists = !existing_tweet.nil?
    update_by_object tweet if is_exists && existing_tweet.updatable?

    is_exists
  end

  # Twitter::TweetオブジェクトからTweet Modelを作成・保存
  def self.create_from_object(tweet, genre_id)
    return if Tweet.exists? tweet.id

    ActiveRecord::Base.transaction do
      Illust.create_from_objects tweet.media, tweet.id
      TweetValue.create_from_object tweet
      User.create_from_object tweet.user

      Tweet.create id: tweet.id,
        url: tweet.url,
        text: (tweet.text.each_char.select { |c| c.bytes.count < 4 }.join ''),
        user_id: tweet.user.id,
        genre_id: genre_id,
        created_at: tweet.created_at
    end
  end

  # Twitter::TweetオブジェクトからTweet Model、User Modelを作成・保存
  def create_from_object_with_user(tweet, genre_id)
    User.create_from_object tweet.user
    Tweet.create_from_object tweet, genre_id
  end

  # 指定したカテゴリに含まれるツイートの情報を更新
  def self.update(genre)
    term = genre.contest_term_now
    tweet_ids = ((Tweet.by_genre_id genre.id).by_created_at term).map(&:id)
    Tweet.update_by_ids tweet_ids
  end

  # 指定したツイートの情報を更新
  def self.update_by_object(tweet)
    TweetValue.create_from_object tweet
  end

  # 指定したツイートIDを持つツイートの情報を更新
  def self.update_by_ids(tweet_ids)
    tweets = AuthedTwitter.client.statuses tweet_ids
    return [] if tweets.nil?
    tweets.map { |tweet| update_by_object tweet }.compact
  end

  # 前回の更新時間からUPDATE_INTERVAL_SEC秒以上経過しているかを確認
  def updatable?
    (Time.zone.now - updated_at.to_time) > UPDATE_INTERVAL_SEC
  end

  # ハッシュに変換
  def to_h
    # do not use ORDER_BY to avoid N+1 loading
    # value = tweet_values.order('created_at DESC').first
    value = tweet_values.sort_by(&:created_at).last
    score = value.score

    illust_urls = illusts.map(&:illust.url)

    {
      tweet: text,
      favorite_count: value.favorite_count,
      retweet_count: value.retweet_count,
      illust_urls: illust_urls,
      score: score
    }
  end
end
