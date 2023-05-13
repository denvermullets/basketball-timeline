class Player < ApplicationRecord
  has_many :game_starters
  has_many :games, through: :game_starters

  has_many :team_players
  has_many :teams, through: :team_players
end
