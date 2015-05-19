require 'net/http'
require 'uri'

def expand_url(url)
  begin
    response = Net::HTTP.get_response(URI.parse(url))
  rescue
    return url
  end
  case response
  when Net::HTTPRedirection
    expand_url(response['location'])
  else
    url
  end
end
