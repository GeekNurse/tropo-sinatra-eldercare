 # stahsed data model
 # {:tab_name=>"Elder Abuse Prevention",
 #  :aid=>"6101",
 #  :name=>"District of Columbia Office on Aging",
 #  :agency_type=>"SGN",
 #  :lead_id=>"6101",
 #  :director=>"Donna Dunston",
 #  :address1=>"441 4th Street North West",
 #  :address2=>"Suite 900 South",
 #  :city=>"Washington",
 #  :state_code=>"DC",
 #  :county=>nil,
 #  :zip_code=>"20001",
 #  :zip_code4=>{:"@xml:space"=>"preserve"},
 #  :o_phone=>"(202) 724-5622",
 #  :info_phone=>"(202) 724-5626",
 #  :nft_phone=>"(877) 919-2372",
 #  :sft_phone=>nil,
 #  :rft_phone=>nil,
 #  :tty_phone=>"(202) 724-8925",
 #  :fax_num=>"(202) 741-5885",
 #  :e_mail_add=>"aging@dc.gov",
 #  :url=>"http://www.dcoa.dc.gov",
 #  :opt_hours=>"8:30 AM - 4:45 PM - Eastern Time",
 #  :drive_direction=>{:"@xml:space"=>"preserve"},
 #  :special_notes=>"All senior service inquiries.",
 #  :description=>" Information and Assistance 724-5626",
 #  :languages=>",English",
 #  :status=>"A",
 #  :date_time_stamp=>
 #   #<DateTime: 2011-03-09T16:30:15-05:00 (212166466215133/86400000,-5/24,2299161)>,
 #  :title_vi=>false,
 #  :aid1=>"6101",
 #  :aid2=>"6101",
 #  :s_types=>"04",
 #  :s_zip_code=>"20037",
 #  :s_type_description=>"Elder Abuse Prevention",
 #  :"@diffgr:id"=>"Table14",
 #  :"@msdata:row_order"=>"3"},

def construct_details_string(item)
  details = []
  details << "This is detailed information about #{item[:tab_name]} at #{item[:tab_name]}: "
  if item[:url]
    tinyurl = shorten_url(URI.unescape(item[:url]))
    if session[:channel] == "VOICE"
      details << "Official web page: #{readable_tinyurl(tinyurl)}. Again, that's #{readable_tinyurl(tinyurl)}"
    else
      details << "Official web page: #{tinyurl}"
    end
  end
  details << "Phone number for information: item[:info_phone]" unless item[:info_phone].empty?
  details << "Email address: #{item[:e_mail_add]}" unless item[:e_mail_add].empty?

  full_address = []
  full_address << item[:address1] unless item[:address1].empty?
  full_address << item[:address2] unless item[:address2].empty?
  full_address << item[:city] unless item[:city].empty?
  full_address << item[:state_code] unless item[:state_code].empty?
  full_address << item[:zip_code] unless item[:zip_code].empty?
  full_address_str = full_address.join(",")

  google_maps_url = shorten_url("http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q="+URI.escape(full_address_str))
  if session[:channel] == "VOICE"
    details << "This resource is located at: #{full_address.join(" ,, ")}"
    details << "Google map available at #{readable_tinyurl(google_maps_url)}"
  else
    details << "Address: #{full_address_str}"
    details << "Google map available at #{google_maps_url}"
  end
  return details.join(", ")
end

def shorten_url(long_url)
  short_url = open("http://tinyurl.com/api-create.php?url=#{long_url}").read.gsub(/https?:\/\//, "")
end

def readable_tinyurl(url)
  unique_url = url.split("/")[1].split(//).join(",")+","
  "tiny u r l dot com slash #{unique_url}"
end
