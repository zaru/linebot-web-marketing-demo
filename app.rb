require 'bundler/setup'
require 'sinatra'
require 'json'
require 'httpclient'
require 'net/http'
require 'uri'
require 'cgi/util'
require 'active_record'
require 'pry-byebug'

require './models/words.rb'
require './models/wikipedia_api.rb'
require './models/docomo_ai.rb'
require './services/word_pipeline.rb'
require './services/filters/database.rb'
require './services/filters/wikipedia.rb'
require './services/filters/ai.rb'

require 'dotenv'
Dotenv.load

ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "#{ENV['DB_NAME']}"
)

get '/' do
  word = params['text']
  pipeline = WordPipeline.new [Filters::Database, Filters::Wikipedia, Filters::Ai]
  "output => #{pipeline.call(word)}"
end

get '/wikipedia' do
  word = params['text']
  data = Wikipedia.new(word)
  "output => #{data.description}"
end

post '/linebot/callback' do
  params = JSON.parse(request.body.read)

  params['result'].each do |msg|

    word = msg['content']['text']

    pipeline = WordPipeline.new [Filters::Database, Filters::Wikipedia, Filters::Ai]
    msg['content']['text'] = pipeline.call(word)

    request_content = {
        to: [msg['content']['from']],
        toChannel: 1383378250, # Fixed  value
        eventType: "138311608800106203", # Fixed value
        content: msg['content']
    }

    http_client = HTTPClient.new
    endpoint_uri = 'https://trialbot-api.line.me/v1/events'
    content_json = request_content.to_json
    http_client.post_content(endpoint_uri, content_json,
                             'Content-Type' => 'application/json; charset=UTF-8',
                             'X-Line-ChannelID' => "#{ENV['CHANNEL_ID']}",
                             'X-Line-ChannelSecret' => "#{ENV['CHANNEL_SECRET']}",
                             'X-Line-Trusted-User-With-ACL' => "#{ENV['CHANNEL_MID']}"
    )
  end

  "OK"
end


def get_image(q)
  uri = URI.parse('http://api.tiqav.com/search.json?q=' + CGI.escape(q))
  json = Net::HTTP.get(uri)
  result = JSON.parse(json)
  img = result.sample
  "http://img.tiqav.com/" + img['id'] + '.' + img['ext']
end
