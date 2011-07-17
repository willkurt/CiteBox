require 'sinatra'
require 'erb'
require 'json'
require './citation'


get '/' do
  erb :index
end

#all the necessary config data is passed throught the url
get '/citebox/:host/:url' do 
  content_type 'text/javascript'
  @host = params[:host]
  @url = params[:url]
  erb :citebox
end

post '/lookup' do
  puts "starting"
  puts "data is #{params[:citation_text]}"
  citation = Citation.new(params[:citation_text])
  puts "citation object created"
  citation.fetch
  puts "data fetched"
  base = params[:open_url_base]
  full_url = "http://#{base}/?query=#{citation.open_url_query}"
  redirect full_url
end
