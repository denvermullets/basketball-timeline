module Api
  module V1
    class IngestStatsController < ApplicationController
      def index
        Ingest::Lineups.call

        render json: { hi: 'hi' }
      end
    end
  end
end
