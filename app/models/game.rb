class Game < ApplicationRecord
  belongs_to :team

  has_many :game_starters
  has_many :players, through: :game_starters
end
