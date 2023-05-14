class TeamLeader < ApplicationRecord
  belongs_to :team
  belongs_to :leader
end
