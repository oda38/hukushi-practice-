class Admins::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  
  def index
    @posts = Post.where(is_draft: :false).order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_tags = @post.tags
  end
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to admin_posts_path
    else
      render 'show'
    end
  end



end
