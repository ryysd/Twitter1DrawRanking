class TweetsController < ApplicationController
  def debug_update
    genre = Genre.find_by_id params[:genre_id]
    Tweet.fetch_by_genre genre
    render :json => "debug-update"
  end

  def debug_update_value
    tweet_id = params[:tweet_id]
    Tweet.update_values [tweet_id]
    render :json => "debug-update-value"
  end

  def debug_update_values_by_updated_at
    from = Time.zone.parse params[:from]
    to = Time.zone.parse params[:to]
    Tweet.update_values_by_updated_at from...to
    render :json => "debug-update-values"
  end
end
