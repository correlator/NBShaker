class API::GamesController < ApplicationController 
  def index 
    Game.all.to_json
  end

  
  protected

    def update_score
    end
end
