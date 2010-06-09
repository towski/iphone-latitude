#!/usr/bin/env ruby -rubygems

# Sample queries:
# ./yql.rb --consumer-key <key> --consumer-secret <secret> "show tables"
# ./yql.rb --consumer-key <key> --consumer-secret <secret> "select * from flickr.photos.search where text='Cat' limit 10"

require 'oauth'
require 'optparse'
require 'json'
require 'pp'
require 'curb'

options = {
:consumer_key => "ec2-174-129-178-1.compute-1.amazonaws.com",
:consumer_secret => "REbO+9ZeNL7YqwoJVM0H33su"
}

consumer = OAuth::Consumer.new \
  options[:consumer_key],
  options[:consumer_secret],
  :site => "https://www.google.com",
  :request_token_path => "/accounts/OAuthGetRequestToken",
  :access_token_path => "/accounts/OAuthGetAccessToken",
  :authorize_path=> "/accounts/OAuthAuthorizeToken",
  :oauth_callback => "http://ec2-174-129-178-1.compute-1.amazonaws.com/oauth"

token = consumer.get_request_token( {}, {:scope => "https://www.google.com/m8/feeds/", :oauth_callback => "http://ec2-174-129-178-1.compute-1.amazonaws.com/oauth"})
puts token.authorize_url 
puts token.secret
exit

request_token = OAuth::RequestToken.new(consumer, "JeuNaWmp43H+t4KDRvIbV9aK  ", "ciZVQAjSXrI4A+SYNU5St/dq") 
access_token = request_token.get_access_token({:verifier => "oob"})
puts access_token.token
puts access_token.secret
response = access_token.get("https://www.google.com/m8/feeds/contacts/default/full/")
puts response
##rsp = JSON.parse(response.body)
#pp response
