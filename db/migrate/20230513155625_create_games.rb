class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.belongs_to :team
      t.date :date
      t.string :opponent
      t.boolean :game_won
      t.integer :team_points
      t.integer :opponent_points
      t.integer :win
      t.integer :loss

      t.timestamps
    end
  end
end
