module Api
  module V1
    class StartingStatsController < ApplicationController
      def index
        team = Team.find_by(abbreviation: params[:team])
        games = Game.includes(:leader, game_starters: { player: {} }).where(team_id: team.id)

        render json: games,
               include: {
                 leader: { only: %i[name url headshot_url] },
                 players: { only: %i[name reference_url headshot_url] }
               },
               except: %i[created_at updated_at]
      end
    end
  end
end
