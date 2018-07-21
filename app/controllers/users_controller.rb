class UsersController < ApplicationController

  get '/signup' do 
     erb :'users/signup' 
		
  end

  post '/login' do
  	@user = User.find_by(username: params[:username])
  	redirect to "/companies"
  end
  
  post "/signup" do
  	@user = User.create(params)
  	if @user.save && !params[:username].empty? && !params[:email].empty? #only allows new user if user name and email are entered
    	session[:user_id] = @user.id	
      redirect to "/companies"
      else
      redirect to "/signup"
    #flas message please enter email username & password to continue   
    end
  end
end