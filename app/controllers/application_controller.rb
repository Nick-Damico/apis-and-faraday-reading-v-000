class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  def logged_in?
    binding.pry
  	!!session[:token]
  end

  private

  def authenticate_user
      redirect_uri = CGI.escape("http://localhost:3000/auth")
      foursquare_url = "https://foursquare.com/oauth2/authenticate?client_id=#{ENV['FOURSQUARE_ID']}&response_type=code&redirect_uri=#{redirect_uri}"
      redirect_to foursquare_url if !logged_in?
  end

end
