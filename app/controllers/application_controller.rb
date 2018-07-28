require './config/environment'
require 'sinatra/base'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base


  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret_password'
    register Sinatra::Flash

  end

  get "/" do
  	if !logged_in?
     erb :index
    else
     redirect to "/companies"
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def not_logged_in_warning
      flash[:not_logged_in] = "You must login to view that page."
    end

    def company_name_warning
      flash[:need_name] = "A company must have a name and can't already be in the database."
    end  

    def edit_warning
      flash[:edit_error] = "You cannot edit a company you didn't create"  
    end  



  end


end
