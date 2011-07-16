#simple class to help manage citations
#fetch them from freecite and transform them into OpenURl queries
require 'net/http'
require 'json'


class Citation
  
  attr_accessor :citation_json
  
  def initialize(citation)
    @freecite_url = 'freecite.library.brown.edu'
    @citation = citation
  end
   
  #fetches the parsed citation from freecite
  def fetch 
    post_path = '/citations/create'
    citation_arg = "citation=#{@citation}"
    Net::HTTP.start(@freecite_url) do |http|
      response = http.post(post_path,citation_arg,
                      'Accept' => 'application/json')
      json_result = JSON.parse(response.body)
      @citation_json = json_result[0]
    end
  end
  
  
end
