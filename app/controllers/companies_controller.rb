class CompaniesController < ApplicationController

	get '/companies' do 
	  if logged_in?
	    @companies = Company.all
	    erb :'companies/index'
	  else
	  	flash[:nor_logged_in] = "You Must login First."
		redirect to "/"
	  end
	end


end