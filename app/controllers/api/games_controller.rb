class Api::GamesController < ApplicationController

  def index
    player_name = params[:player_name]
    game = Game.where(status: :active).first
    unless game
      game = Game.find_by_status(:waiting)
      if game
        if game.player_1_name != player_name
          game.join_2nd_player!(player_name)
          Pusher['nbshaker_channel'].trigger('game_status_event', message: %Q({"status": "active", "id": "#{game.id}", "p2_name": "#{game.player_2_name}"}))
        end
      else
        game = Game.create!(player_1_name: player_name, status: :waiting)
        Pusher['nbshaker_channel'].trigger('game_status_event', message: %Q({"status": "waiting", "id": "#{game.id}", "p1_name": "#{game.player_1_name}"}))
      end
    end

    render json: game
  end

  def update_score
    game = Game.find(params[:id].to_i)
    if game.is_game_over?
      message = "Winner is: #{game.winner}"
    else
      game.update_score!("#{params[:player]}_score".to_sym, params[:score].to_i)
      game.reload
      message = %Q({"id": #{game.id}, "player_1": #{game.player_1_score}, "player_2": #{game.player_2_score}})
    end
    Pusher['nbshaker_channel'].trigger('score_updated_event', message: message)
    render json: game
  end

  def decay
    puts params[:id]
    game = Game.where(id: params[:id].to_i, status: :active).first
    if game
      game.decay!
      Pusher['nbshaker_channel'].trigger('score_updated_event', message: %Q({"id": #{game.id}, "player_1": #{game.player_1_score}, "player_2": #{game.player_2_score}}))
    end
    render nothing: true
  end
end
