require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path('peekaboo.rb')
run Sinatra::Application
