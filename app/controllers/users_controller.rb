class UsersController < ApplicationController




  post '/login' do
  	user = User.find_by(username: params[:username]) #find user by username
    if user && user.authenticate(params[:password]) #authenticate password with username
      session[:user_id] = user.id
  	  redirect to "/companies"
    else
      flash[:wrong_password] = "Username or password is not correct.<br> Please try again or create an account"
      redirect to "/"
    end
  end

  get '/signup' do #get signup page if not logged in
    if !logged_in?
     erb :'users/signup'
    else
      redirect to "/companies"
    end
  end

  post "/signup" do #create new user if name and email are unique
   @user = User.new(params)
  	if @user.save 
    	session[:user_id] = @user.id
      redirect to "/companies"

    elsif @user.errors
     flash[:message] = @user.errors.messages.values.flatten.to_sentence
       redirect to "/signup"
    
    else
      redirect to "/signup"
    end
  end

  get '/users/:slug' do #go to user show page
    @user = User.find_by_slug(params[:slug])
    if @user.id == current_user.id
      erb :'users/show'
    else
      redirect to "/companies"
    end
  end

  get '/logout' do #logout and end session
    if !logged_in?
      redirect to "/"
    else
      session.clear
      redirect to "/"
    end
  end

end
