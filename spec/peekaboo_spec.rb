require_relative '../peekaboo.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

describe "Peekaboo" do
  include Rack::Test::Methods

  it "should display an index page" do 
    get '/'
    last_response.should be_ok
  end
end
