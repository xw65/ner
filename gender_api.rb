require 'net/http'
require 'net/https'
require 'open-uri'
require 'json'

# use genderize.com to get gender
# two methods for http GET request
def get_gender_ize(name)
  each_name = "#{name}"
  uri = 'http://api.genderize.io?name='+each_name
#  encoded = URI.encode( uri )
#  data = URI.parse( encoded ).read
#  parsed_data = JSON.parse(data )
#  return parsed_data

  resp = nil
  open(uri) do |http|  
  resp = http.read  
  return JSON.parse(resp)
 
  end  

end

#use gender_api.com to get gender
def get_gender_api(name,key)
  each_name = "#{name}"
 # puts each_name
  uri = 'https://gender-api.com/get?name='+each_name+'&key='+key
  #puts uri
#  encoded = URI.encode( uri )
#  data = URI.parse( encoded ).read
#  parsed_data = JSON.parse( data )
#
#  return parsed_data
  
  resp = nil
  open(uri) do |http|  
  resp = http.read  
  return JSON.parse(resp)
  
  end
end

if __file__ = $0

#initial count number
name_num = 0
same_num = 0  
  
#read name from a file
filepath_r = "C:/gender_match/names_sample_1.txt"
filepath_diff = "C:/gender_match/diff1.xml"
file_r=File.open(filepath_r)
file_diff=File.open(filepath_diff,"w")

#inital xml file
file_diff.puts("<?xml version='1.0' encoding='utf-8'?>")
file_diff.puts('<Body>')

#read name from name file
key = "NgKShUcCvHohCyqJdb"
file_r.each do |line|   
  #print "name is: "+line 
  

  name_ud = line.chomp
  
  if(!name_ud.ascii_only?)
    puts "sorry, "+name_ud+" is not in UTF-8, please input English character!"
    next
  end
  name_num += 1
  
  # if we use gender-api, 1 key is only available for 1000 queries, thus we need to change another key
  if (name_num > 900)
    key = "GfpowmBYsffsnnNArk"
  end 
       
  first_name_ud = name_ud.split(" ")[0]
  first_name = first_name_ud.downcase
 # puts "first name is: #{first_name}"
  
  #get gender
  
  match_rlt_ize = get_gender_ize(first_name)
  if(match_rlt_ize["gender"] != nil)
    #puts "genderize rlt is: "+match_rlt_ize["gender"]
  end   
  
  match_rlt_api = get_gender_api(first_name,key)
  if(match_rlt_api["gender"] != nil)
    #puts "gender_api rlt is: "+match_rlt_api["gender"] 
  end
   
  #clean results  
  rlt_ize = (match_rlt_ize["gender"] == nil)?"unknown":match_rlt_ize["gender"]
  rlt_api = (match_rlt_api["gender"] == nil)?"unknown":match_rlt_api["gender"]
  comp_rlt = (rlt_ize.strip == rlt_api.strip)?"same":"different"  
  xml_name = '<Name>'+first_name+'</Name>'
  xml_ize = '<Ize>'+rlt_ize+'</Ize>'
  xml_api = '<Api>'+rlt_api+'</Api>'
  xml_rlt = '<Result>'+comp_rlt+'</Result>'
  
  if(rlt_ize.strip == rlt_api.strip)
    same_num += 1
  else
    same_num = same_num
  end
  
  #write results into xml file
  file_diff.puts('<Person>')
  file_diff.puts(xml_name)
  file_diff.puts(xml_ize)
  file_diff.puts(xml_api)
  file_diff.puts(xml_rlt)
  file_diff.puts('</Person>')
  
end
  puts ""
  puts same_num
  puts name_num

# compute how many results are different
diff_percent = 100.0*same_num/name_num
puts "#{diff_percent}"
file_diff.puts('<Dff_Per>'+"#{diff_percent}%"+'</Dff_Per>')
file_diff.puts('</Body>')

#close files
file_r.close
file_diff.close

end
