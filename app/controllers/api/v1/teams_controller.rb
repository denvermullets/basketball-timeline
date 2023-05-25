module Api
  module V1
    class TeamsController < ApplicationController
      def index
        render json: Team.all.order(:name), except: %i[created_at updated_at]
      end
    end
  end
end
