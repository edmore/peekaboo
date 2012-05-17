require_relative '../peekaboo.rb'
require 'rack/test'
require 'capybara/rspec'

set :environment, :test

def app
  Sinatra::Application
end

def setup
  Capybara.app = Sinatra::Application.new
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

feature  "Index  page" do
  setup
  scenario "should display an index page" do
    visit("/")
    page.should have_css("h1", :text => "Peekaboo")
  end
end
