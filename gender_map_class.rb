require 'net/http'
require 'net/https'
require 'open-uri'
require 'json'

class GenderMapper

                GENDER_MALE  = 1
                GENDER_FEMALE = 2
                GENDER_UNKNOWN = 3

                #first name should be string
                def get_gender( first_name, key = "dtFjTjmaHjAxeHqZec" )
                  
                  #convert first name to downcase
                  each_name = first_name.downcase
                  
                  #get gender info from web
                  uri = 'https://gender-api.com/get?name='+each_name+'&key='+key
                  encoded = URI.encode( uri )
                  data = URI.parse( encoded ).read
                  parsed_data = JSON.parse(data )
                  
                  #determine returned gender and return
                  if(parsed_data["gender"] == nil)
                    return GENDER_UNKNOWN
                  else
                    (parsed_data["gender"].strip == "male") ? (return GENDER_MALE) : (return GENDER_FEMALE)
                  end
                 
                
                end
end


#test class functionality
gender = GenderMapper.new
puts gender.get_gender("Mary")

#correct

