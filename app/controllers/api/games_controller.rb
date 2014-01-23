class Api::GamesController < ApplicationController

  def index
    game = Game.find_by_status('waiting')
    if game
      game.update_attributes!(player_2_name: 'Player 2', status: 'active')
    else
      game = Game.create!(player_1_name: 'Player 1', status: 'waiting')
    end

    render json: game
  end

  protected

    def update_score
    end
end
