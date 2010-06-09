require 'rubygems'
require 'json'
require 'net/http'
require 'redis'
require 'oauth'
require 'yaml'
@redis = Redis.new

@config = YAML::load(File.open('config.yml').read)
@instamapper_api_key = @config["instamapper_api_key"]
@consumer_key = @config["consumer_key"]
@consumer_secret = @config["consumer_secret"]
@oauth_token_secret = @config["oauth_token_secret"]
@oauth_token = @config["oauth_token"]

url = "http://www.instamapper.com/api?action=getPositions&key=#{@instamapper_api_key}&num=10&format=json"
resp = Net::HTTP.get_response(URI.parse(url))
points = JSON.parse(resp.body)
if points.has_key? 'Error'
  raise "web service error"
end

positions = points["positions"]
last_location_timestamp = @redis["locations:max:last_location"].to_i ||= 1
last_location = positions.find {|point| point["timestamp"].to_i == last_location_timestamp}
if last_location
  positions = positions[positions.index(last_location)+1..-1]
end

if positions.length > 0
  puts "#{Time.now} #{positions.length} new points"
  @redis["locations:max:last_location"] = positions.last["timestamp"]
 
  @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => 'https://www.google.com',
                                                                    :request_token_path => '/accounts/OAuthGetRequestToken',
                                                                    :access_token_path => '/accounts/OAuthGetAccessToken',
                                                                    :authorize_path => '/accounts/OAuthAuthorizeToken'})
                                                                                                      
  @access_token = OAuth::AccessToken.new(@consumer, @oauth_token, @oauth_token_secret)

  positions.each do |point|
    glatlng = {"data" => {"kind" => "latitude#location", 
                         "latitude" => point["latitude"],
                         "longitude" => point["longitude"],
                         "altitude" => point["altitude"].to_i,
                         "timestampMs" => "#{point["timestamp"]}000"
                        }
              }
    @access_token.post('https://www.googleapis.com/latitude/v1/location', glatlng.to_json, {'Content-Type' => 'application/json'})
  end
else
  puts "#{Time.now} no new points"
end
