require 'net/http'
require "addressable/uri"
require 'json'

class DocomoAi

  def initialize(word)
    @word = word
    @uri = URI.parse("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=7434496d554a6f4163343654324e5a634e36376262546c6b4f56634a49763153442e5970395a686253542f")
    @https = Net::HTTP.new(@uri.host, @uri.port)
    @https.use_ssl = true
  end

  def answer
    req = Net::HTTP::Post.new(@uri.request_uri)
    req["Content-Type"] = "application/json"
    payload = {
        utt: @word
    }.to_json
    req.body = payload
    res = @https.request(req)
    json = JSON.parse(res.body)
    json["utt"]
  end
end