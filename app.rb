require 'sinatra'
require 'erb'
require 'json'
require 'rest_client'
require 'hpricot'

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
  citation_text = params[:citation_text]
  response = RestClient.post( 'http://freecite.library.brown.edu/citations/create',
                        { :citation => citation_text})
  citation_xml = Hpricot(response.to_str)
  open_url_list = []
  (citation_xml/'ctx:metadata journal')[0].each_child do |x|
    open_url_list.push("#{x.name.gsub(':','.')}=#{x.innerHTML}")
  end
  open_url_query = open_url_list.join('&')
  base = params[:open_url_base]
  full_url = "http://#{base}/?query=#{open_url_query}&url_ver=Z39.88-2004&ctx_enc=info:ofi/enc:UTF-8"
  puts "redircting to.. #{full_url}
  redirect full_url
end
