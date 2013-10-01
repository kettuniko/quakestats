require 'sinatra'
require 'json'

get '/players' do
  players = 
    [
      {:id => 1, :nick => "vile"}, 
      {:id => 2, :nick => "kopi"}
    ]
  players.to_json
end
