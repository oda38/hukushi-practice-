class Admins::PostsController < ApplicationController
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to admins_posts_path
    else
      render 'show'
    end
  end
  
end
