#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8
require 'sinatra'
require 'redis'

set :server, 'thin'
#set :server, 'webrick'
connections = []
enable :sessions


def itemCnt
	@itemCnt = $picCnt
end  

def genQuery(params)
	query = "?" + params.map{|key, value| "#{key}=#{value}"}.join("&")
end



get '/' do  
  if(params[:user])
    session[:user] = params[:user]
	  session["#{params[:user]}Rand"] = rand(4) unless(session["#{params[:user]}Rand"])
  	erb :index, :locals => { :user => params[:user].gsub(/\W/, '') }
  else
  	halt erb(:login)
  end
end

post '/result/all/:user' do 
    itemCnt.times do |val|
        session["#{session[:user]}#{val}"] = "off"
    end
    @test2 = params['check'] 
    if(!@test2.nil?)
    	@test2.each do |val|
    		session[val.sub(/items/, "#{session[:user]}")] = "on"
    	end 
     end
    redirect "/?user=#{session[:user]}"
end
  

##CHAT

get '/stream', :provides => 'text/event-stream' do
  stream :keep_open do |out|
    connections << out
    out.callback { connections.delete(out) }
  end
end

post '/' do
  connections.each { |out| out << "data: #{params[:msg]}\n\n" }
  204 # response without entity body
end

put '/pick/:id' do |id|
  lc = session["pick#{id}"]  
  session["pick#{id}"]  = !lc
end

if(__FILE__ == $0 )
	puts "hello"
	puts `ls public`
	cnt =0
	puts "DIRDIR"
	dir = "public"
	Dir.entries(dir).each do |ff|
		if(ff =~ /\.jpeg/)
			str = "cp #{dir}/#{ff} #{dir}/dl#{cnt}.jpg"
		    `#{str}`
			cnt += 1
			
		end
	end
	$picCnt = cnt
	puts "DIRDIR"
	Dir.entries(dir).each do |ff|
		puts ff
	end
end

__END__


@@ login
<html>
  <head>
    <title>Super Simple Chat with Sinatra</title>
    <meta charset="utf-8" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
  </head>
<body>
    <%= "rfoo = #{session.inspect}" %>
    <% session.clear %>
    <%= "rfoo = #{session.inspect}" %>
    
    <%= "rfoo = #{params.inspect}" %>
<form action='/'>
  <label for='user'>User Name:</label>
  <input name='user' value='' />
  <input type='submit' value="GO!" />
</form>
</body>
</html>

