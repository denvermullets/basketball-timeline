module Api
  module V1
    class IngestStatsController < ApplicationController
      def index
        teams = [
          # { name: 'PHO', year_start: 1984, year_end: nil },
          # { name: 'ATL', year_start: 1984, year_end: nil },
          # { name: 'WSB', year_start: 1984, year_end: 1998 },
          # { name: 'LAL', year_start: 1984, year_end: nil },
          # { name: 'MEM', year_start: 2005, year_end: nil },
          # { name: 'MIA', year_start: 1984, year_end: nil },
          # { name: 'MIL', year_start: 1984, year_end: nil },
          # { name: 'MIN', year_start: 1990, year_end: nil },
          { name: 'NYK', year_start: 1984, year_end: nil },
        ]

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
    end
  end
end
