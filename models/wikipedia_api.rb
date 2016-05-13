require 'net/http'
require "addressable/uri"
require 'json'

class WikipediaApi

  attr_reader :description, :url

  def initialize(word)
    uri = Addressable::URI.parse("http://wikipedia.simpleapi.net/api?keyword=#{word}&output=json")
    json = Net::HTTP.get(uri)
    unless "null" == json
      result = JSON.parse(json)
      @description = result[0]['body']
      @url = result[0]['url']
    end
  end

end