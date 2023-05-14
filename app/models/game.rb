class Game < ApplicationRecord
  belongs_to :team
  belongs_to :leader

  has_many :game_starters
  has_many :players, through: :game_starters
end
