class IllustsController < ApplicationController
  def index
    genre = Genre.find_by_id params[:genre_id]
    Tweet.create_by_genre genre
    render :json => "a"
  end
end
