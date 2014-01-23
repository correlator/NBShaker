class GamesController < ApplicationController

  def index
    Pusher['test_channel'].trigger('my_event', {
        message: 'hello world'
    })
  end

  def show
  end
end
