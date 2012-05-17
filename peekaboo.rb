require 'sinatra'

set :haml, :format => :html5

get "/" do
  "Peekaboo I see you!"
  haml :index
end
