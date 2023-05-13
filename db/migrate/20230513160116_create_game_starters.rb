class CreateGameStarters < ActiveRecord::Migration[7.0]
  def change
    create_table :game_starters do |t|
      t.belongs_to :game, foreign_key: "game_id", null: false
      t.belongs_to :player, foreign_key: "player_id", null: false

      t.timestamps
    end
  end
end
