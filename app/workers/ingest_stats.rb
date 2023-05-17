class IngestStats
  include Sidekiq::Worker

  def perform(team, year)
    puts "Going to find starters for #{year} #{team}"
    Scrape::Lineups.call(year:, team:)
  end
end
