class Genre < ActiveRecord::Base
  # ハッシュタグから、該当するGenreを検索
  # @param [Array<String>] hash_tags 検索を行いたいハッシュタグの配列
  # @return [Genre]
  def self.find_by_hash_tags(hash_tags)
    hash_tags.map { |hash_tag| Genre.find_by_hash_tag hash_tag.text }.compact.first
  end

  # 指定した日の集計開始時間を取得
  # @param [DateTime] date 集計日時を取得したい日
  # @return [DateTime]
  def contest_start_time(date)
    date.to_time + (60 * 60 * start_time.hour)
  end

  # 現時刻が属する集計期間を取得
  # @return [Range<DateTime>]
  def contest_term_now
    one_day_sec = 60 * 60 * 24
    today_contest_start_time = contest_start_time Date.today

    if Time.zone.now < today_contest_start_time
      (today_contest_start_time - one_day_sec)...today_contest_start_time 
    else
      today_contest_start_time...(today_contest_start_time + one_day_sec)
    end
  end

  # 指定した日時が属する集計期間を取得
  # @return [Range<DateTime>]
  def contest_term(date)
    one_day_sec = 60 * 60 * 24
    date_contest_start_time = date.to_time + (60 * 60 * start_time.hour)
    date_contest_start_time...(date_contest_start_time + one_day_sec)
  end
end
