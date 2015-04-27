class IllustsController < ApplicationController
  def index
    render :json => client.search("#ruby -rt", lang: "ja").first.text
  end
end
