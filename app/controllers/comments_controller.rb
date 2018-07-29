class CommentsController < ApplicationController

  post '/comments/:company_id' do
  	 company = Company.find_by(id: params[:company_id])
  	 comment = Comment.create(user_comment: params[:user_comment], user_id: current_user.id, company_id: company.id) # creates a comment that belongs to company & user
     if comment.save
  	   redirect to "/companies/#{company.slug}"
  	 else
  	 	 redirect to "/companies/#{company.slug}"
  	 end
  end

  get '/comments/:id/edit' do
  	@comment = Comment.find_by(id: params[:id]) # find comment to edit
  	@company = Company.find_by(id: @comment.company_id)
  	if @comment.user_id = current_user.id #verify user own comment
  	  erb :'comments/edit_comment'
    else
      redirect to "/companies/#{@company.slug}"
    end
  end

  patch '/comments/:id' do
    comment = Comment.find_by(id: params[:id]) # find comment
    company = Company.find_by(id: comment.company_id) #find company that belongs to comment

    if  comment.update(user_comment: params[:user_comment])
      redirect to "/companies/#{company.slug}"
    else
      redirect to "/comments/#{comment.slug}/edit" #if comment isn't valid redirects to edit form
    end
  end

  delete '/comments/:id/delete' do #delete comment
    comment = Comment.find_by(id: params[:id])
    company = Company.find_by(id: comment.company_id)
    comment.delete
    redirect to "/companies/#{company.slug}"
  end
end
