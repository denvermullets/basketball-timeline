require 'net/http'

module Scrape
  class Lineups < Service
    def initialize(year:, team:)
      @url = "https://www.basketball-reference.com/teams/#{team.upcase}/#{year}_start.html"
      @games = []
      @team = team
    end

    def call
      doc = load_html
      parse_html(doc, false)

      data = { games: @games }

      json = JSON.generate(data)
      File.write('data_new_playoffs.json', json)
      puts 'Scraping completed!'
    end

    def load_html
      # url = URI.parse('https://www.basketball-reference.com/teams/PHO/2022_start.html')
      sleep 1
      url = URI.parse(@url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      request = Net::HTTP::Get.new(url.request_uri)
      response = http.request(request)
      html = response.body

      Nokogiri::HTML(html)
    end

    def parse_html(doc, playoffs)
      # will need to have team id number updated
      team_id = 1
      coach = parse_coach_info(doc)
      create_join_records('TeamLeader', { team_id:, leader_id: coach })

      starting_lineups_table = doc.css("#starting_lineups_po#{playoffs ? 1 : 0}")

      starting_lineups_table.css('tbody tr').each do |row|
        date = Date.parse(row.css('[data-stat="date_game"] a').text)
        opponent = row.css('[data-stat="opp_name"] a').text
        win_status = row.css('[data-stat="game_result"]').text
        team_points = row.css('[data-stat="pts"]').text
        opponent_points = row.css('[data-stat="opp_pts"]').text
        win = row.css('[data-stat="wins"]').text
        loss = row.css('[data-stat="losses"]').text

        game_exists = Game.find_by(date:, opponent:, team_points:, team_id:, leader_id: coach)
        next unless game_exists.nil?

        game = Game.create(
          date:, opponent:, game_won: win_status == 'W', team_points:,
          opponent_points:, win:, loss:, leader_id: coach, team_id:
        )

        # now get starting lineups
        row.css('[data-stat="game_starters"] a').map do |a|
          player = a.text
          player_url = a['href']
          starter = Player.find_by(short_name: player, reference_url: player_url)
          next unless starter.nil?

          new_player = parse_player_info(player_url, player)
          create_join_records('TeamPlayer', { team_id:, player_id: new_player.id })
          create_join_records('GameStarter', { game_id: game.id, player_id: new_player.id })
        end
      end
    end

    def parse_coach_info(doc)
      coach_element = doc.css("p:contains('Coach:')")
      coach_name = coach_element.css('a').text
      puts coach_element
      coach_url = coach_element.css('a').first['href'].to_s

      coach = Leader.find_by(name: coach_name, url: coach_url)
      if coach.nil?
        puts 'about to call the service'
        sleep 1
        url = URI.parse("https://www.basketball-reference.com#{coach_url}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == 'https')
        request = Net::HTTP::Get.new(url.request_uri)
        response = http.request(request)
        html = response.body

        doc = Nokogiri::HTML(html)
        headshot_url = doc.css('#meta img').first['src']

        Leader.create(name: coach_name, headshot_url:, url: coach_url).id
      else
        coach.id
      end
    end

    def parse_player_info(player_url, short_name)
      sleep 1
      url = URI.parse("https://www.basketball-reference.com#{player_url}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      request = Net::HTTP::Get.new(url.request_uri)
      response = http.request(request)
      html = response.body

      doc = Nokogiri::HTML(html)
      name = doc.css('#meta h1 span').text
      headshot_url = doc.css('#meta img').first['src']

      Player.create(reference_url: player_url, short_name:, name:, headshot_url:)
    end

    def create_join_records(model_name, attributes)
      # trying something new for join tables, dynamically create records
      join_table = Object.const_get(model_name)
      record_exists = join_table.find_by(attributes)
      return unless record_exists.nil?

      join_table.create(attributes)
    end
  end
end
