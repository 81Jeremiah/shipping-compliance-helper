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
	  	flash[:not_logged_in] = "You must login to view that page."
		redirect to "/"
	  end
    end

    post '/companies/:userslug' do
      

      if !params[:name].empty? && Company.all.none?{|company|company.name == params[:name]}
      	@user = User.find_by_slug(params[:userslug])
      	@company = Company.create(name: params[:name], shipping_container_notes: params[:shipping_container_notes], label_notes: params[:label_notes], asn_notes: params[:asn_notes], routing_notes: params[:routing_notes], user_id: @user.id )
        #binding.pry
        redirect to "/companies/#{@company.id}"
      

       else
      	flash[:need_name] = "A company must have a name and can't already be in the database."
      	redirect to "/companies/new"
       end
    end

    get '/companies/:id' do 
      @company = Company.find_by(id: params[:id])
      if @company.user_id == session[:user_id]
        erb :'/companies/show_company'
      else
       redirect to "/companies"
      end
    end

end