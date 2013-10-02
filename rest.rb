require 'sinatra'
require 'json'

get '/players' do
[
  {id: 1, nick: "vile"},
  {id: 2, nick: "kopi"},
  {id: 3, nick: "gooby"},
  {id: 4, nick: "dolan"},
  {id: 5, nick: "scrooge"},
  {id: 6, nick: "Q"}
].to_json
end
