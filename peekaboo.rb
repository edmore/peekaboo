require 'sinatra'
require 'haml'
require 'redis'
require 'digest/sha1'
require 'espeak-ruby'

include ESpeak

set :haml, :format => :html5
redis = Redis.new

get "/" do
  haml :index
end

get "/push" do
  status = params[:status] if params[:status]
  unless status.nil?
    message =  (status == "success") ? "Successfully added." : "Oops, please enter text."
  end
  haml :push, :locals => {:message => message}
end

post "/push" do
  text = params[:question]
  status = ""
  unless text == ""
    question_id = redis.incr "question:id"
    filename = "tmp/#{Digest::SHA1.hexdigest(params.to_s)}.mp3"
    redis.rpush("questions", question_id)
    redis.set("question:#{question_id}:text", params[:question])
    redis.set("question:#{question_id}:filename", filename)
    espeak(filename, :text => "'#{params[:question]}'")
    status = :success
  end
  redirect "/push?status=#{status}"
end

get "/start" do
  length = redis.llen("questions")
  text = []
  filenames = []
  (length).times do
    question_id = redis.lpop("questions")
    text << redis.get("question:#{question_id}:text")
    filenames << redis.get("question:#{question_id}:filename")
  end
  files = text.zip(filenames)
  haml :start, :locals => {:files => files}
end

get "/clear" do
  redis.flushall
  system("rm -rf tmp/*")
  [200, {'Content-type' => 'text/plain'},"Session Cleared"]
end

get "/play" do
  unless params[:filename].nil?
    filename = params[:filename]
    [200, {'Content-type' => 'audio/mpeg'}, File.read(filename)]
  end
end

