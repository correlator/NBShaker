class Api::GamesController < ApplicationController

  def index
    game = Game.find_by_status(:waiting)
    if game
      game.join_2nd_player!
    else
      game = Game.create!(player_1_name: 'Player 1', status: :waiting)
    end

    render json: game
  end

  def update_score
    game = Game.find(params[:id].to_i)
    if game.is_game_over?
      message = "Winner is: #{game.winner}"
    else
      game.update_score(:player_1_score, Random.rand(101))
      message = %Q({"player1": #{game.player_1_score}, "player2": #{game.player_2_score}})
    end
    Pusher['nbshaker_channel'].trigger('score_updated_event', {
       message: message
    })
    render nothing: true
  end
end
