Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :ingest_stats

      resources :starting_stats
      resources :teams
    end
  end
end
