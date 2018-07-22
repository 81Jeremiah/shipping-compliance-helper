class UsersController < ApplicationController




  post '/login' do
  	@user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
  	  redirect to "/companies"
    else
      flash[:wrong_password] = "Username or password is not correct./<br> Please try again or create an account"
      redirect to "/"
    end
  end

  get '/signup' do 
    if !logged_in?
     erb :'users/signup' 
    else
      redirect to "/companies"
    end
  end
  
  post "/signup" do
  	@user = User.create(params)
  	if @user.save && !params[:username].empty? && !params[:email].empty? && !params[:password].empty? #only allows new user if user name and email are entered
    	session[:user_id] = @user.id	
      redirect to "/companies"
    elsif params[:username].empty?
      flash[:no_username_warning] = "You Must Enter an Username to Continue."
      redirect to "/signup"
    elsif User.all.any?{|user|user.username == params[:username]}
      flash[:username_warning] = "Sorry that username is already taken"
      redirect to "/signup"
    elsif params[:email].empty?
      flash[:no_email_warning] = "You Must Enter an Email to Continue."
      redirect to "/signup"
    elsif User.all.any?{|user|user.email == params[:email]}
      flash[:username_warning] = "That email already has an account, did you mean to login?"
      redirect to "/signup"
    
    elsif params[:password].empty?
      flash[:no_password_warning] = "You Must Enter an Password to Continue."
      redirect to "/signup"
    else
      redirect to "/signup"
    end
  end

  get '/logout' do
    if !logged_in?
      redirect to "/"
    else
      session.clear
      redirect to "/"
    end
  end

end