class UsersController < ApplicationController




  post '/login' do
  	@user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
  	  redirect to "/companies"
    else
      flash[:wrong_password] = "Username or password is not correct.<br> Please try again or create an account"
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
  	if @user.save 
    	session[:user_id] = @user.id
      redirect to "/companies"
    elsif User.all.any?{|user|user.username == params[:username]}
      flash[:username_warning] = "Sorry that username is already taken"
      redirect to "/signup"
    elsif User.all.any?{|user|user.email == params[:email]}
      flash[:username_warning] = "That email already has an account, did you mean to login?"
      redirect to "/signup"
    else
      redirect to "/signup"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(slug: params[:slug])
    erb :'user/show'
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
