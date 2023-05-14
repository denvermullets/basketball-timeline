module Ingest
  class Team < Service
    def initialize(team:)
      @team = team
    end

    def call
      team_record = Team.find_by(abbreviation: team)
      team_record.nil? && team_record = Team.create(abbreviation: @team)

      team_record
    end
  end
end
