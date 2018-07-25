class CompaniesController < ApplicationController

	get '/companies' do 
	  if logged_in?
	    @companies = Company.all
	    erb :'companies/index'
	  else
	  	flash[:not_logged_in] = "You must login to view that page."
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

  post '/companies/:userslug' do #check if this route is correct use of REST
    if !params[:name].empty? && Company.all.none?{|company|company.name == params[:name]}
      @user = User.find_by_slug(params[:userslug])
      @company = Company.create(name: params[:name], shipping_container_notes: params[:shipping_container_notes], label_notes: params[:label_notes], asn_notes: params[:asn_notes], routing_notes: params[:routing_notes], user_id: @user.id )
      redirect to "/companies/#{@company.id}"
    else
      flash[:need_name] = "A company must have a name and can't already be in the database."
      redirect to "/companies/new"
    end
  end

  get '/companies/:id' do 
    @company = Company.find_by(id: params[:id]) 
    if logged_in?
       erb :'/companies/show_company'
    else
      redirect to "/companies"
    end
  end

  delete '/companies/:id/delete' do
    company = Company.find_by(id: params[:id])
    company.delete
    redirect to "/companies"
  end

  get '/companies/:id/edit' do
    @company = Company.find_by(id: params[:id])
    if logged_in? && @company.user_id == session[:user_id]
      erb :'companies/edit_company'
    else
      flash[:edit_error] = "You cannot edit a company you didn't create" 	
      redirect to "/companies"
    end
  end

  patch '/companies/:id' do
    company = Company.find_by(id: params[:id])
    if !params[:name].empty?
      company.update(name: params[:name], shipping_container_notes: params[:shipping_container_notes], label_notes: params[:label_notes], asn_notes: params[:asn_notes], routing_notes: params[:routing_notes])
      redirect to "/companies/#{company.id}"
    else
      redirect to "/companies/#{company.id}/edit"
    end
  end

end