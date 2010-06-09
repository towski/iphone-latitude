# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

def login_required
    if session[:user_id]
      @user ||= User.find(session[:user_id])
      @access_token ||= OAuth::AccessToken.new(get_consumer, @user.oauth_token, @user.oauth_secret)
    else
      redirect_to :controller => 'session', :action => 'new'
    end
  end
 
  def get_consumer
    require 'oauth/consumer'
    require 'oauth/signature/rsa/sha1'
     consumer = OAuth::Consumer.new("server","key", { :site => "https://www.google.com", :request_token_path => "/accounts/OAuthGetRequestToken", :access_token_path => "/accounts/OAuthGetAccessToken", :authorize_path => "/latitude/apps/OAuthAuthorizeToken"})
  end
end
