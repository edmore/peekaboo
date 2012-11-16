require 'sinatra'
require 'haml'
require 'redis'
require 'digest/sha1'
require 'espeak-ruby'

include ESpeak

set :haml, :format => :html5
redis = Redis.new

def sanitize_dir_entries( dir )
  entries = Dir.entries( dir )
  entries.select{ |x| (x != ".." && x != ".") }
end

def command?(command)
  system("which #{command} > /dev/null 2>&1")
end

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
  status = ""
  unless params[:question] == ""
    question_id = redis.incr "question:id"
    name = "tmp/#{Digest::SHA1.hexdigest(params.to_s)}"
    filename = "#{name}.mp3"
    redis.rpush("questions", question_id)
    redis.set("question:#{question_id}:text", params[:question].downcase)
    redis.set("question:#{question_id}:filename", filename)
    if( command?("say") && command?("lame") )
      cmd = "say -v Vicki '#{params[:question]}' -o #{name}.aiff && lame --quiet #{name}.aiff #{name}.mp3 && rm -f #{name}.aiff"
      system(cmd) # Mac OS X
    elsif ( command?("lame") && command?("espeak") )
      espeak(filename, :text => "'#{params[:question]}'") # Linux
    end
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
  sounds = text.zip(filenames)
  people = sanitize_dir_entries( "public/images/people" );
  objects = sanitize_dir_entries( "public/images/objects" );
  haml :start, :locals => {:sounds => sounds, :people => people, :objects => objects}
end

get "/clear" do
  redis.flushall
  system("rm -rf tmp/*.mp3")
  [200, {'Content-type' => 'text/plain'},"Session Cleared - [Audio files removed]."]
end

get "/play" do
  unless params[:filename].nil?
    filename = params[:filename]
    [200, {'Content-type' => 'audio/mpeg'}, File.read(filename)]
  end
end

