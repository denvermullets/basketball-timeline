module Api
  module V1
    class IngestStatsController < ApplicationController
      def index
        Scrape::Lineups.call(year: 2022, team: 'PHO')

        render json: { hi: 'hi' }
      end
    end
  end
end
