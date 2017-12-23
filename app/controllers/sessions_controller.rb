class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create
  def index
  end

  def create
    resp = Faraday.get('https://foursquare.com/oauth2/access_token') do |req|
      req.params["client_id"] = ENV["FOURSQUARE_ID"]
      req.params["client_secret"] = ENV["FOURSQUARE_SECRET"]
      req.params["grant_type"] = 'authorization_code'
      req.params["code"] = params[:code]
      req.params["redirect_uri"] = "http://localhost:3000/auth"
    end
    body = JSON.parse(resp.body)
    if resp.success?
      session[:token] = body["access_token"]
      # GET https://api.foursquare.com/v2/users/USER_ID
      redirect_to '/username'
    else
      @error = "Error, please try again."
    end
  end

  def username
    resp = Faraday.get('https://api.foursquare.com/v2/users/self') do |req|
      req.params["oauth_token"] = session[:token]
      req.params["v"] = '20170201'
    end
    binding.pry
  end


  # https://foursquare.com/oauth2/access_token
  #   ?client_id=YOUR_CLIENT_ID
  #   &client_secret=YOUR_CLIENT_SECRET
  #   &grant_type=authorization_code
  #   &redirect_uri=YOUR_REGISTERED_REDIRECT_URI
  #   &code=CODE
end
