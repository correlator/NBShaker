class Api::GamesController < ApplicationController

  def index
    game = Game.find_by_status(:waiting)
    unless Game.where(status: :active).empty?
      render nothing: true
      return
    end
    if game
      game.join_2nd_player!(params[:player])
    Pusher['nbshaker_channel'].trigger('game_status_event', message: %Q({"status": "active", "id": "#{game.id}"}))
    else
      game = Game.create!(player_1_name: 'Lea', status: :waiting)
    Pusher['nbshaker_channel'].trigger('game_status_event', message: %Q({"status": "waiting", "id": "#{game.id}"}))
    end

    render json: game
  end

  def update_score
    game = Game.find(params[:id].to_i)
    if game.is_game_over?
      message = "Winner is: #{game.winner}"
    else
      game.update_score!("#{params[:player]}_score".to_sym, params[:score].to_i)
      message = %Q({"id": #{game.id}, "Lea": #{game.player_1_score}, "Jim": #{game.player_2_score}})
    end
    Pusher['nbshaker_channel'].trigger('score_updated_event', message: message)
    render json: game.id
  end

  def decay
    puts params[:id]
    game = Game.where(id: params[:id].to_i, status: :active).first
    if game
      game.decay!
      Pusher['nbshaker_channel'].trigger('score_updated_event', message: %Q({"id": #{game.id}, "Lea": #{game.player_1_score}, "Jim": #{game.player_2_score}}))
    end
    render nothing: true
  end
end
