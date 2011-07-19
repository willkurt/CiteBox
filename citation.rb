#simple class to help manage citations
#fetch them from freecite and transform them into OpenURl queries
require 'net/http'
require 'json'


class Citation
  
  attr_accessor :citation_json
  
  def initialize(pcitation)
    @freecite_url = 'freecite.library.brown.edu'
    @parsed_citation = pcitation
    @citation_json = nil
  end
   
  #fetches the parsed citation from freecite
  # def fetch 
  #   post_path = '/citations/create'
  #   citation_arg = "citation=#{@citation}"
  #   puts "starting fetch #{@freecite_url}"
  #   puts "citation arg: #{citation_arg}"
  #   Net::HTTP.start(@freecite_url,3000) do |http|
  #     response = http.post(post_path,citation_arg,
  #                     'Accept' => 'application/json')
  #     json_result = JSON.parse(response.body)
  #     @citation_json = json_result[0]
  #   end
  # end

#this needs a very serious refactor... barf
  def open_url_query
    fcj = @parsed_citation
    #just to get running faster copying some ugliness
    spage,epage = if not fcj['pages'].nil? then fcj['pages'].split('--') else [nil,nil] end
    args = ["url_ver=Z39.88-2004",  #I think this is just standard
      "url_time=",  #might leave this blank, or just generate timestamp?
      "url_ctx_fmt=", #again don't really know what to do with this
      "rft_id=",  #see standard for notes on these
      "rft_id=", 
      "rft_val_fmt=",
      "rft.jtitle=#{fcj['journal']}", #think this is correct
      "rft.atitle=#{fcj['title']}",  #got this one 
      "rft.aulast=#{}",  #get back an author array so we have to work with that
      "rft.auinit=#{}", #see previous
      "rft.date=#{fcj['year']}", #this may need to be parsed apart in some cases
      "rft.volume=#{fcj['volume']}",
      "rft.issue=#{fcj['number']}", #think this is right
      "rft.spage=#{spage}",  #pretty positive we get a page range on these ones will need to split 
      "rft.epage=#{epage}",
      "rfe_id=", #check standard
      "rfr_id=", #see above
      "req_id=", #see above
      "ctx_tim=", #see above
      "ctx_enc=info:ofi/enc:UTF-8"] #just going to assume this one is right
   base = args.join("&")

  end
  
  
end
