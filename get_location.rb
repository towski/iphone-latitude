require 'rubygems'
require 'json'
require 'net/http'
require 'redis'
require 'oauth'
@redis = Redis.new

@config = YAML::load(File.open('config.yml').read)
@consumer_key = @config["consumer_key"]
@consumer_secret = @config["consumer_secret"]
@oauth_token_secret = @config["oauth_token_secret"]
@oauth_token = @config["oauth_token"]

@consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site => 'https://www.google.com',
                                                                  :request_token_path => '/accounts/OAuthGetRequestToken',
                                                                  :access_token_path => '/accounts/OAuthGetAccessToken',
                                                                  :authorize_path => '/accounts/OAuthAuthorizeToken'})
@access_token = OAuth::AccessToken.new(@consumer, @oauth_token, @oauth_token_secret)
puts @access_token.get('https://www.googleapis.com/latitude/v1/currentLocation', {'Content-Type' => 'application/json'})
