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

feature  "Index page" do
  setup
  scenario "should display an index page" do
    visit("/")
    page.should have_content("Peekaboo I see you")
  end

  scenario "should link to push page" do
    visit("/")
    click_link("Push")
    page.should have_content("Push")
    page.current_path.should == "/push"
  end

  scenario "should link to start session  page" do
    visit("/")
    click_link("Start Session")
    page.current_path.should == "/start"
  end

  scenario "should link to clear session" do
    visit("/")
    click_link("Clear Session")
    page.current_path.should == "/clear"
  end
end

feature  "Push page" do
  setup
  scenario "should display a push page" do
    visit("/push")
    page.should have_content("Push")
  end

  scenario "adding data" do
    visit("/push")
    fill_in('question', :with => "What's your name")
    click_button("Push")
    page.should have_css("p.message", :text => "Successfully added.")
  end

  scenario "should error if text field empty" do
    visit("/push")
    fill_in('question', :with => "")
    click_button("Push")
    page.should have_css("p.message", :text => "Oops, please enter text.")
  end
end

feature  "Start Sesssion" do
  setup
  scenario "should start a session" do
    visit("/")
    click_link("Start Session")
    page.current_path.should == "/start"
  end
end

feature  "Clear Session" do
  setup
  scenario "should clear a session" do
    visit("/")
    click_link("Clear Session")
    page.current_path.should == "/clear"
  end
end

