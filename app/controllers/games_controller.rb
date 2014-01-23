class GamesController < ApplicationController

  def index
    Pusher['test_channel'].trigger('my_event', {
        message: '{"player1": 0.8, "player2": 0.7}'
    })
  end

  def show
  end
end
