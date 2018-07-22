class CommentsController < ApplicationController

  post '/comments/:company_id' do
  	 @user = current_user
  	 @company = Company.find_by(id: params[:company_id])
  	 @comment = Comment.create(user_comment: params[:user_comment], user_id: @user.id, company_id: @company.id)
     if @company.save

  	   redirect to "/companies/#{@company.id}"
  	 else
  	 	flash[:comment_warning] = "Comment cannot be empty."

  	 	redirect to "/companies/#{@company.id}"
  	 end

  end

  get '/comments/:id/edit' do
  	@comment = Comment.find_by(id: params[:id])
  	@company = Company.find_by(id: @comment.company_id)
  	if @comment.user_id = current_user.id
  	  erb :'comments/edit_comment'
    else
      redirect to "/companies/#{@company.id}"
    end
  end

  patch '/comments/:id' do

    comment = Comment.find_by(id: params[:id])
    company = Company.find_by(id: comment.company_id)
    if !params[:user_comment].empty?
      comment.update(user_comment: params[:user_comment])
      redirect to "/companies/#{comment.company_id}"
    else
      redirect to "/comments/#{comment.id}/edit"
    end
  end


end