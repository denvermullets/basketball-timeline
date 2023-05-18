require 'net/http'

module Scrape
  class Lineups < Service
    def initialize(year:, team:)
      # @url = URI.parse('https://www.basketball-reference.com/teams/PHO/2022_start.html')
      @url = "https://www.basketball-reference.com/teams/#{team.upcase}/#{year}_start.html"
      @team = team
      @year = year
    end

    def call
      doc = load_html(@url)
      team = parse_team_info(doc)
      coach = parse_coach_info(doc)
      parse_games(doc, team, coach, false)
      playoffs = doc.css('#starting_lineups_po1').empty?
      puts 'Regular Season completed!'
      return if playoffs

      parse_games(doc, team, coach, true)
      puts 'Playoffs completed!'
    end

    def load_html(url)
      url = URI.parse(url)
      sleep 3.15
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      request = Net::HTTP::Get.new(url.request_uri)
      response = http.request(request)
      html = response.body
      Nokogiri::HTML(html)
    end

    def parse_games(doc, team, coach, playoffs)
      create_join_records('TeamLeader', { team_id: team.id, leader_id: coach.id })

      starting_lineups_table = doc.css("#starting_lineups_po#{playoffs ? 1 : 0}")
      starting_lineups_table.css('tbody tr').each do |row|
        game = parse_game_info(row, coach, team, playoffs)

        # now get starting lineups
        row.css('[data-stat="game_starters"] a').map do |a|
          player = a.text
          player_url = a['href']
          starter = parse_player_info(player_url, player)

          create_join_records('TeamPlayer', { team_id: team.id, player_id: starter.id })
          create_join_records('GameStarter', { game_id: game.id, player_id: starter.id })
        end
      end
    end

    def parse_coach_info(doc)
      coach_element = doc.css("p:contains('Coach:')")
      coach_name = coach_element.css('a').text
      coach_url = coach_element.css('a').first['href'].to_s

      coach = Leader.find_by(url: coach_url)
      return coach unless coach.nil?

      sleep 3.2
      puts "looking up #{coach_url}"
      doc = load_html("https://www.basketball-reference.com#{coach_url}")
      headshot_div = doc.at_css('#meta img')
      headshot_url = headshot_div ? doc.css('#meta img').first['src'] : nil

      Leader.create(name: coach_name, headshot_url:, url: coach_url)
    end

    def parse_player_info(player_url, short_name)
      starter = Player.find_by(reference_url: player_url)
      return starter unless starter.nil?

      sleep 3.1
      puts "looking up #{player_url}"
      doc = load_html("https://www.basketball-reference.com#{player_url}")
      name = doc.css('#meta h1 span').text
      headshot_div = doc.at_css('#meta img')
      headshot_url = headshot_div ? doc.css('#meta img').first['src'] : nil

      Player.create(reference_url: player_url, short_name:, name:, headshot_url:)
    end

    def parse_team_info(doc)
      team_record = Team.find_by(abbreviation: @team)
      return team_record unless team_record.nil?

      team_name = doc.css('div[data-template="Partials/Teams/Summary"] h1 span:nth-child(2)').text
      Team.create(abbreviation: @team, name: team_name)
    end

    def parse_game_info(row, coach, team, playoffs)
      date = Date.parse(row.css('[data-stat="date_game"] a').text)
      opponent = row.css('[data-stat="opp_name"] a').text
      win_status = row.css('[data-stat="game_result"]').text
      team_points = row.css('[data-stat="pts"]').text
      opponent_points = row.css('[data-stat="opp_pts"]').text
      win = row.css('[data-stat="wins"]').text
      loss = row.css('[data-stat="losses"]').text

      game_exists = Game.find_by(date:, opponent:, team_points:, team_id: team.id, leader_id: coach.id)
      return game_exists unless game_exists.nil?

      game = Game.new(
        date:, opponent:, game_won: win_status == 'W', team_points:, year: @year,
        opponent_points:, win:, loss:, leader_id: coach.id, team_id: team.id, playoffs:
      )

      begin
        game.save!
      rescue ActiveRecord::RecordInvalid => e
        puts 'Record could not be saved due to the following errors:'
        puts e.message
      end

      game
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
