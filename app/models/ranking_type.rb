class RankingType < ActiveRecord::Base
  has_many :rankings

  scope :daily, -> {where(name: :daily).first}
end
