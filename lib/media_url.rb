require 'net/http'
require 'uri'

class MediaUrl
  def self.get_pixiv_id_from_urls(urls)
    id = urls.map {|url| get_pixiv_id_from_url url}.compact.uniq.first
  end

  def self.get_tumblr_id_from_urls(urls)
    id = urls.map {|url| get_tumblr_id_from_url url}.compact.uniq.first
  end

  def self.get_pixiv_id_from_description(description)
    reg = /pixiv\D*(?<id>[0-9]+)/
    result = reg.match description

    result[:id] unless result.nil?
  end

  def self.is_short_url(url)
    !((url.include? 'www') || (url.include? '.com') || (url.include? 'pixiv') || (url.include? 'tumblr'))
  end

  def self.get_pixiv_id_from_url(pixiv_url)
    reg = /https?:\/\/www.pixiv.net\/member\.php\?id=(?<id>[0-9]+)/
    result = reg.match pixiv_url

    result[:id] unless result.nil?
  end

  def self.get_tumblr_id_from_url(tumblr_url)
    reg = /http:\/\/(?<id>\w+).tumblr.com/
    result = reg.match tumblr_url

    result[:id] unless result.nil?
  end

  def self.expand_url(url)
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
end
