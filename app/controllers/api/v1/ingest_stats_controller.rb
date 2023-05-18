module Api
  module V1
    class IngestStatsController < ApplicationController
      def index
        teams.map do |team|
          year_start = team[:year_start]
          year_end = team[:year_end].nil? ? 2023 : team[:year_end]

          while year_start <= year_end
            IngestStats.perform_async(team[:name].to_s, year_start)
            year_start += 1
          end
        end

        render json: { message: 'jobs all fired off!' }
      end

      def teams
        [
          { name: 'ATL', year_start: 1984, year_end: nil },
          { name: 'BOS', year_start: 1984, year_end: nil },
          { name: 'BRK', year_start: 2013, year_end: nil },
          { name: 'CHI', year_start: 1984, year_end: nil },
          { name: 'CLE', year_start: 1984, year_end: nil },
          { name: 'DAL', year_start: 1984, year_end: nil },
          { name: 'DEN', year_start: 1984, year_end: nil },
          { name: 'DET', year_start: 1984, year_end: nil },
          { name: 'GSW', year_start: 1984, year_end: nil },
          { name: 'HOU', year_start: 1984, year_end: nil },
          { name: 'IND', year_start: 1984, year_end: nil },
          { name: 'LAC', year_start: 1984, year_end: nil },
          { name: 'LAL', year_start: 1984, year_end: nil },
          { name: 'KCK', year_start: 1984, year_end: 1985 },
          { name: 'MEM', year_start: 2005, year_end: nil },
          { name: 'MIA', year_start: 1984, year_end: nil },
          { name: 'MIL', year_start: 1984, year_end: nil },
          { name: 'MIN', year_start: 1990, year_end: nil },
          { name: 'NJN', year_start: 1984, year_end: 2012 },
          { name: 'NYK', year_start: 1984, year_end: nil },
          { name: 'OKC', year_start: 2009, year_end: nil },
          { name: 'ORL', year_start: 1990, year_end: nil },
          { name: 'PHI', year_start: 1984, year_end: nil },
          { name: 'PHO', year_start: 1984, year_end: nil },
          { name: 'SAC', year_start: 1986, year_end: nil },
          { name: 'SAS', year_start: 1984, year_end: nil },
          { name: 'SEA', year_start: 1984, year_end: 2008 },
          { name: 'TOR', year_start: 1996, year_end: nil },
          { name: 'UTA', year_start: 1984, year_end: nil },
          { name: 'VAN', year_start: 1996, year_end: 2001 },
          { name: 'WAS', year_start: 1998, year_end: nil },
          { name: 'WSB', year_start: 1984, year_end: 1998 }
        ]
      end
    end
  end
end
