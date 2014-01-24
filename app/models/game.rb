class Game < ActiveRecord::Base

  MAX_SCORE = 100

  def join_2nd_player!
    update_attributes!(player_2_name: 'Jim', status: :active)
    Pusher['nbshaker_channel'].trigger('game_started_event', {
        message: ''
    })
  end

  def update_score(player_score, score)
    old_score = self.send(player_score).to_i
    update_attribute(player_score.to_sym, old_score + score)
    update_attribute(:status, :finished) if is_game_over?
  end

  def decay
    update_attributes!(
      player_1_score: (player_1_score * 0.95).to_i,
      player_2_score: (player_2_score * 0.95).to_i
    )
    Pusher['nbshaker_channel'].trigger('score_updated_event',
                                       message: %Q({"id": #{id}, "Lea": #{player_1_score}, "Jim": #{player_2_score}}))
  end

  def is_game_over?
    player_1_score >= 100 || player_2_score >= 100
  end

  def winner
    player_1_score > player_2_score ? player_1_name : player_2_name if is_game_over?
  end
end
