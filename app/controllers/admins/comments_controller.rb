class Admins::CommentsController < ApplicationController
  
  def destroy
    @comment = Comment.find_by(id: params[:id],post_id: params[:post_id])
    @comment.destroy
    redirect_to admins_post_path
  end
  
end
