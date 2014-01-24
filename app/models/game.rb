class Game < ActiveRecord::Base

  MAX_SCORE = 100

  def join_2nd_player!
    update_attributes!(player_2_name: 'Jim', status: :active)
    Pusher['nbshaker_channel'].trigger('game_started_event', {
        message: ''
    })
  end

  def update_score(player_score, score)
    update_attribute(player_score.to_sym, score)
    update_attribute(:status, :finished) if is_game_over?
  end

  def is_game_over?
    player_1_score >= 100 || player_2_score >= 100
  end

  def winner
    player_1_score > player_2_score ? player_1_name : player_2_name if is_game_over?
  end
end
