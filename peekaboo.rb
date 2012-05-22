require 'sinatra'
require 'haml'
require 'redis'

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
    redis.rpush("questions", question_id)
    redis.set("question:#{question_id}:text", params[:question])
    status = :success
  end
  redirect "/push?status=#{status}"
end

get "/start" do
  length = redis.llen("questions")
    (length).times do
      question_id = redis.lpop("questions")
      text = redis.get("question:#{question_id}:text")
      system("espeak '#{text}'")
      sleep 5
    end
    [200, {'Content-type' => 'text/plain'},"End of Session"]
end

get "/clear" do
  redis.flushall
  [200, {'Content-type' => 'text/plain'},"Session Cleared"]
end

