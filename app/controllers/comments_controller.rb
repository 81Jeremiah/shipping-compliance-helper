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
end