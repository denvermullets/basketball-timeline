class Leader < ApplicationRecord
  has_many :team_leaders
  has_many :teams, through: :team_leaders
end
