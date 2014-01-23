class GameModelCreation < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.string  :player_1_name
      t.string  :player_2_name
      t.integer :player_1_score, default: 0
      t.integer :palyer_2_score, default: 0
      t.string  :status
    end
  end

  def down
    drop_table :games
  end
end
