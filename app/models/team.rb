class Team < ApplicationRecord
  has_many :team_players
  has_many :players, through: :team_players
  has_many :team_leaders
  has_many :leaders, through: :team_leaders
  has_many :games
end
