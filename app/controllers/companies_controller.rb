class CompaniesController < ApplicationController

	get '/companies' do 
	  if logged_in?  #get all companies page if logged in
	    @companies = Company.all
	    erb :'companies/index'
	  else
	  	not_logged_in_warning
		  redirect to "/"
	  end
	end

	get '/companies/new' do #get new company form if logged in
	  if logged_in?
	  	@user = User.find_by(id: session[:user_id])
	  	erb :'companies/new'
	  else
	  	not_logged_in_warning
		  redirect to "/"
	  end
  end

  post '/companies/:userslug' do #post company to belong to user that is logged in
    
    @company = Company.create(name: params[:name], shipping_container_notes: params[:shipping_container_notes], label_notes: params[:label_notes], asn_notes: params[:asn_notes], routing_notes: params[:routing_notes], user_id: current_user.id )
    if @company.save
      redirect to "/companies/#{@company.id}"      
    else
      company_name_warning
      redirect to "/companies/new"
    end
  end

  get '/companies/:company_slug' do  #go to indv company page if logged in
    @company = Company.find_by_slug(params[:company_slug]) 
    if logged_in?
       erb :'/companies/show_company'
    else
      redirect to "/companies"
    end
  end

  delete '/companies/:id/delete' do #delete company
    company = Company.find_by(id: params[:id])
    company.delete
    redirect to "/companies"
  end

  get '/companies/:company_slug/edit' do #get edit form if logged in
    @company = Company.find_by_slug(params[:company_slug])
    if logged_in? && @company.user_id == session[:user_id]
      erb :'companies/edit_company'
    else
      edit_warning 	
      redirect to "/companies"
    end
  end

  patch '/companies/:id' do #patch/post changes in company
    company = Company.find_by(id: params[:id])
    if !params[:name].empty?
      company.update(name: params[:name], shipping_container_notes: params[:shipping_container_notes], label_notes: params[:label_notes], asn_notes: params[:asn_notes], routing_notes: params[:routing_notes])
      redirect to "/companies/#{company.id}"
    else
      redirect to "/companies/#{company.id}/edit"
    end
  end

end