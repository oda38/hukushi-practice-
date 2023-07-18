class Publics::UsersController < ApplicationController
  before_action :authenticate_user!
  
  
  def index
    @users = User.where(is_deleted: false)
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(is_draft: :false).order(created_at: :desc).page(params[:page]).per(8)
  end

  def edit
    user = User.find(params[:id])
     unless user.id == current_user.id
    redirect_to user_path(current_user.id)
     end
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
     if @user.update(user_params)
      redirect_to user_path(@user)
     else
      render :edit
     end
  end
  
  def unsubscribe
    @user = User.find(params[:id])
  end
  
  def withdrawal
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end
  
  
  def confirm
    @posts = current_user.posts.where(is_draft: :true)
  end
  
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @posts = Post.find(favorites)
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:profile_image, :name, :name_kana, :nickname, :telephone_number, :email,)
  end
  
end
