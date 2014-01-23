class GamesController < ApplicationController

  def index
    p1_score = params[:p1]
    p2_score = params[:p2]
    Pusher['test_channel'].trigger('my_event', {
        message: %Q({"player1": #{p1_score}, "player2": #{p2_score}})
    })
  end

  def show
  end
end
