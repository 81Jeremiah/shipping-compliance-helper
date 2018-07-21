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
  	if @user.save && !params[:username].empty? && !params[:email].empty? && !params[:password].empty? #only allows new user if user name and email are entered
    	session[:user_id] = @user.id	
      redirect to "/companies"
    elsif params[:email].empty?
      flash[:no_email_warning] = "You Must Enter an Email to Continue."
      redirect to "/signup"
    elsif params[:username].empty?
      flash[:no_username_warning] = "please enter a username to continue"
      redirect to "/signup"
    elsif params[:password].empty?
      flash[:no_password_warning] = "please enter a password to continue"
      redirect to "/signup"
    else
      redirect to "/signup"
    #flash message please enter email username & password to continue   
    end
  end
end