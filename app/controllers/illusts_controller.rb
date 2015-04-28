class IllustsController < ApplicationController
  def index
    genre = Genre.find_by_id params[:genre_id]
    render :json => client.search("##{genre[:hash_tag]} exclude:retweets", lang: "ja", result_type: "recent").first
  end
end
