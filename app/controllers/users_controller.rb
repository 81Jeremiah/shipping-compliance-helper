class UsersController < ApplicationController

  get '/signup' do 
     erb :'users/signup' 
		
  end

  post '/login' do
  	@user = User.find_by(username: params[:username])
  end



end