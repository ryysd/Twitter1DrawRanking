class RankingsController < ApplicationController
  def daily
    date = params[:date]
    genre_id = params[:genre_id]

    render json: ((Ranking.by_genre_id genre_id).by_created_at date).last.to_h.to_json
  end
end
