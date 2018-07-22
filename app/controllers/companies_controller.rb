class CompaniesController < ApplicationController

	get '/companies' do 
	  if logged_in?
	    @companies = Company.all
	    erb :'companies/index'
	  else
	  	flash[:not_logged_in] = "You Must login First."
		redirect to "/"
	  end
	end

	get '/companies/new' do
	  if logged_in?
	  	@user = User.find_by(id: session[:user_id])
	  	erb :'companies/new'
	  else
	  	flash[:not_logged_in] = "You Must login First."
		redirect to "/"
	  end
    end

end