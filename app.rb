require 'sinatra'
require 'erb'
require 'json'
require 'rest_client'
require 'hpricot'

get '/' do
  puts settings
  erb :index
end

#all the necessary config data is passed throught the url
get '/citebox/:host/*' do 
  content_type 'text/javascript'
  @host = params[:host]
  @url = params[:splat][0]
  erb :citebox
end

post '/lookup' do
  citation_text = params[:citation_text]
#  begin
    response = RestClient.post('http://freecite.library.brown.edu/citations/create',
                          {:citation => citation_text}
                          )
    citation_xml = Hpricot(response.to_str)
 # rescue
  #  redirect '/timeout'
#  end
  open_url_list = []
  citation_element = (citation_xml/'ctx:metadata journal')[0]
  if citation_element.nil?
    redirect '/fail'
  else
    
    citation_element.each_child do |x|
      open_url_list.push("#{x.name.gsub(':','.')}=#{x.innerHTML}")
    end
    open_url_query = magic_cleanup(citation_text,open_url_list.join('&'))
    base = params[:open_url_base]
    full_url = "http://#{base}/?query=#{open_url_query}&url_ver=Z39.88-2004&ctx_enc=info:ofi/enc:UTF-8"
    puts "redircting to.. #{full_url}"
    redirect full_url
  end
end

#some heuristics to attempt to make the results more reliable
def magic_cleanup(citation_text,open_url_query) 
  q = open_url_query
  #this can obviously be cleaned up as we add more
  q = guess_date(citation_text,q)
  return q
end


#in the case where there is no date, try desperately to find one
def guess_date(citation_text,q)
#
  #okay we got nothing
  if q.match(/rft.date=&/)
    #let's try to find something, note: highest date is 2019
    quest = citation_text.match(/(20[0-1][0-9])|(1[7-9][0-9][0-9])/) 
    if(quest)
      guess_date = quest[0] #if we want we could try to improve this by looking at all options
      q = q.sub(/rft.date=&/,"rft.date=#{guess_date}&")
    end
  end
  return q
end

get '/fail' do
  erb :fail
end

get '/timeout' do
  erb :timeout
end
