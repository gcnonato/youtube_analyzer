class ApplicationController < ActionController::Base
  protect_from_forgery
  http_basic_authenticate_with :name => ENV['USER_NAME'], :password => ENV['PASSWORD'] if Rails.env == 'production'
end
