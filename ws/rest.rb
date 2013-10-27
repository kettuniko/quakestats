require 'sinatra'
require 'json'
require 'xml'
require 'xmlsimple'

require 'pp'

before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => %w(GET)
end

class QuakeStatParser
  attr_accessor :players, :cache_time, :cache_reset_timer

  def initialize
    @frags = 'frags'
    @name = 'name'

    @players = Array.new
    @players_hash = Hash.new
    @cache_time = Time.now
    @cache_reset_timer = 120.0 # 120 seconds for now
  end

  def calculate_stats
    @players_hash = Hash.new
    parse_match('logs/ffa_3[lacrima]050612-1354.xml')
    parse_match('logs/ffa_2[ukpak5]240413-1355.xml')

    @players = Array.new
    @players_hash.each do |key, value|
      player = Hash.new
      player[@name] = key
      player[@frags] = value[@frags]
      @players.push(player)
    end

    @cache_time = Time.now + @cache_reset_timer
  end

  def parse_match(xml)
    puts "Parsing match #{xml}"
    log = XmlSimple.xml_in(xml, {ForceArray: false})

    puts log['match_info']['timestamp']

    log['events']['event'].each do |event|
      if event['death']
        death = event['death']
        attacker = death['attacker']
        unless @players_hash[attacker]
          puts "> a new player found #{attacker}"
          @players_hash[attacker] = Hash.new
          @players_hash[attacker][@frags] = 0
        end
        @players_hash[attacker][@frags] += 1
      end
    end

  end
end

parser = QuakeStatParser.new

get '/players' do
  if parser.cache_time < Time.now
    puts 'cache reset, calculating new stats'
    parser.calculate_stats()
  end
  pp parser.players.to_json
end
