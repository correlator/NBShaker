class Game
  def initialize
    @player1 = 
    @player2 = 
    @player1_score = 
    @player2_score = 
  end
  MAX_SCORE = 100


  def game_round(p1_something, p2_somethig)
    something
    increment_score1
    increment_score2

  end

  def increment_score1(amount)
    @player1_score += amount
  end

  def increment_score2(amount)
    @player2_score += amount
  end

  def game_over?
    @player1_score >= 100 || @player2_score >= 100
  end

  def get_winnner
    return 'player1' if @player1_score > @player2_score
    return 'player2'
  end

end
