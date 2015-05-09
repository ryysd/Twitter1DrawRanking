class AuthedTwitter
  def self.make_query(keyword, since_time: nil, until_time: nil)
    query = "#{keyword}"
    query += " since:#{since_time.strftime('%Y-%m-%d_%H:%M:%S_JST')}" unless since_time.nil?
    query += " until:#{until_time.strftime('%Y-%m-%d_%H:%M:%S_JST')}" unless until_time.nil?
    query += " -rt"
  end

  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end
  end
end
