require 'sinatra'
require 'erb'
require 'json'
require './citation'


get '/' do
  erb :index
end

#all the necessary config data is passed throught the url
get '/citationtool/:host/:url' do 
  content_type 'text/javascript'
  @host = params[:host]
  @url = params[:url]
  erb :citationtool
end


