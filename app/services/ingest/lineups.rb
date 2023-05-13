require 'net/http'

module Ingest
  class Lineups < Service
    def initialize(year:, team:)
      @url = "https://www.basketball-reference.com/teams/#{team.upcase}/#{year}_start.html"
      @games = []
    end

    def call
      doc = load_html
      parse_html(doc)

      data = { games: @games }

      json = JSON.generate(data)
      File.write('data.json', json)
      puts 'Scraping completed!'
    end

    def load_html
      # url = URI.parse('https://www.basketball-reference.com/teams/PHO/2022_start.html')
      url = URI.parse(@url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      request = Net::HTTP::Get.new(url.request_uri)
      response = http.request(request)
      html = response.body

      Nokogiri::HTML(html)
    end

    def parse_html(doc)
      doc.css('tbody tr').each do |row|
        date = row.css('[data-stat="date_game"] a').text
        opponent = row.css('[data-stat="opp_name"] a').text
        win_status = row.css('[data-stat="game_result"]').text
        team_points = row.css('[data-stat="pts"]').text
        opponent_points = row.css('[data-stat="opp_pts"]').text
        win = row.css('[data-stat="wins"]').text
        loss = row.css('[data-stat="losses"]').text

        starting_lineup = row.css('[data-stat="game_starters"] a').map do |a|
          player = a.text
          player_url = a['href']
          { player:, player_url: }
        end

        @games << {
          date:,
          opponent:,
          game_won: win_status == 'W',
          team_points:,
          opponent_points:,
          win:,
          loss:,
          startingLineup: {
            players: starting_lineup
          }
        }
      end
    end
  end
end
