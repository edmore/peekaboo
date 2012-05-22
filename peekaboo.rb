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
    notice =  (status == "success") ? "Successfully added." : "Oops, please enter text."
  end
  haml :push, :locals => {:notice => notice}
end

post "/push" do
  title = params[:question]
  status = ""
  unless title  == ""
    question_id = redis.incr "question:id"
    redis.rpush("questions", question_id)
    redis.set("question:#{question_id}:title", params[:question])
    status = :success
  end
  redirect "/push?status=#{status}"
end
