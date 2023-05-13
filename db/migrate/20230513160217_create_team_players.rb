class CreateTeamPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_players do |t|
      t.belongs_to :team, foreign_key: "team_id", null: false
      t.belongs_to :player, foreign_key: "player_id", null: false

      t.timestamps
    end
  end
end
