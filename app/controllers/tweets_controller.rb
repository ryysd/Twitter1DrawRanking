class TweetsController < ApplicationController
  def debug_update
    genre = Genre.find_by_id params[:genre_id]
    Tweet.create_by_genre genre
    render :json => "debug-update"
  end
end
