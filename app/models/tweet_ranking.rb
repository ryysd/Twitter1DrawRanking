class TweetRanking < ActiveRecord::Base
  belongs_to :ranking
  belongs_to :tweet
end
