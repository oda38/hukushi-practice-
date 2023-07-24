class Publics::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search_tag]
  
  
  def new
    @post = Post.new
  end
  
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    #タグを作るには「,」をつける
    tag_list = params[:post][:name].split(',')
    
    #投稿公開
    if params[:release]
      @post.is_draft = false
      if @post.save(context: :publicize)
        @post.save_tag(tag_list)
        flash[:notice] = "投稿を公開しました！"
        redirect_to user_posts_path(current_user)
      else
        render :new
      end
    #下書き
    elsif params[:draft]
      @post.is_draft = true
      if @post.update(is_draft: :true)
        @post.save_tag(tag_list)
        flash[:notice] = "下書きを保存しました！"
        redirect_to confirm_user_path(current_user)
      else
        render :new
      end
    end
  end
  
  
  def index
    @posts = Post.where(is_draft: :false)#改行
                .joins(:user).merge(User.where(is_deleted: false)).order(created_at: :desc).page(params[:page]).per(8)
    @tag_list = Tag.joins(posts: :user)#改行
                .merge(Post.where(is_draft: false)).merge(User.where(is_deleted: false)).distinct
  end


  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_tags = @post.tags
    @comment = Comment.new
  end


  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end
  
  
  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
      
  # ①下書きを公開する場合
    if params[:publicize_draft]
      @post.attributes = post_params.merge(is_draft: false)
      if @post.save(context: :publicize)
        @post.save_tag(tag_list)
        flash[:notice] = "公開しました！"
        redirect_to user_posts_path(current_user)
      else
        @post.is_draft = true
        render :edit
      end
      
  # ②公開済みの投稿を更新する場合
    elsif params[:update_post]
      @post.attributes = post_params
      if @post.save(context: :publicize)
        @post.save_tag(tag_list)
        redirect_to user_posts_path(current_user)
      else
        render :edit
      end   
      
  # ③下書きを下書きに更新する場合
    else
      if @post.update(post_params)
        @post.save_tag(tag_list)
        redirect_to confirm_user_path(current_user)
      else
        render :edit
      end    
      
    end
  end
  
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "削除しました。"
      redirect_to posts_path, status: :see_other
    else
      render 'edit'
    end
  end
  
  
  def search_tag
    @tag_list = Tag.joins(posts: :user)#改行
                .merge(Post.where(is_draft: false)).merge(User.where(is_deleted: false)).distinct
    #検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
    #検索されたタグに紐づく投稿を表示
    @posts = @tag.posts.where(is_draft: :false)#改行
                .joins(:user).merge(User.where(is_deleted: false)).order(created_at: :desc).page(params[:page]).per(8)
  end
  
  
  
   private
  
  def post_params
    params.require(:post).permit(:image, :title, :content, :is_draft, addition_images: [] )
  end
  
  
  
end
