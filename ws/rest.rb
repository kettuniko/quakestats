require 'sinatra'
require 'json'
require 'xml'
require 'xmlsimple'

require 'pp'

before do
  content_type :json
end

class QuakeStatParser
  attr_accessor :players, :cache_time, :cache_reset_timer

  def initialize
    @players = Hash.new
    @cache_time = Time.now
    @cache_reset_timer = 120.0 # 120 seconds for now
  end

  def calculate_stats
    parse_match('logs/ffa_3[lacrima]050612-1354.xml')
    parse_match('logs/ffa_2[ukpak5]240413-1355.xml')
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
        unless players[attacker]
          puts "> a new player found #{attacker}"
          @players[attacker] = Hash.new
          @players[attacker]['frags'] = 0
        end
        @players[attacker]['frags'] += 1
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
  response['Access-Control-Allow-Methods']= ['GET']
  #TODO harden
  response['Access-Control-Allow-Origin'] = '*'
  pp parser.players.to_json
end
