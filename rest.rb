require 'sinatra'
require 'JSON'

get '/players' do
  players = 
    [
      {:id => 1, :nick => "vile"}, 
      {:id => 2, :nick => "kopi"}
    ]
  players.to_json
end
