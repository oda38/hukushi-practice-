class Publics::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    #タグを作るには「＃」をつける
    tag_list=params[:post][:name].split('#')
    
    #投稿公開
    if params[:release]
      @post.is_draft = false
      if @post.save(context: :publicize)
        @post.save_tag(tag_list)
        redirect_to user_posts_path(current_user)
      else
        render :new
      end
    #下書き
    elsif params[:draft]
      @post.is_draft = true
      if @post.update(is_draft: :true)
        @post.save_tag(tag_list)
        redirect_to confirm_user_path(current_user)
      else
        render :new
      end
    end
  end
  
  
  def index
    @posts = Post.where(is_draft: :false).page(params[:page])
    @tag_list = Tag.all
  end


  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_tags = @post.tags
  end


  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join('#')
  end
  
  
  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split('#')
      
  # ①下書きレシピの更新（公開）の場合
    if params[:publicize_draft]
      @post.attributes = post_params.merge(is_draft: false)
      if @post.save(context: :publicize)
        @old_relations = TagMap.where(post_id: @post.id)
        @old_relations.each do |relation|
        relation.delete
        end
        @post.save_tag(tag_list)
        redirect_to user_posts_path(current_user), notice: "下書きの投稿を公開しました！"
      else
        @post.is_draft = true
        render :edit, alert: "公開できませんでした。"
      end
      
  # ②公開済みレシピの更新の場合
    elsif params[:update_post]
      @post.attributes = post_params
      if @post.save(context: :publicize)
        @old_relations = TagMap.where(post_id: @post.id)
        @old_relations.each do |relation|
        relation.delete
        end
        @post.save_tag(tag_list)
        redirect_to user_posts_path(current_user), notice: "更新しました！"
      else
        render :edit, alert: "更新できませんでした。"
      end   
      
  # ③下書きレシピの更新（非公開）の場合
    else
      if @post.update(post_params)
        redirect_to confirm_user_path(current_user), notice: "下書きを更新しました！"
      else
        render :edit, alert: "更新できませんでした。"
      end    
      
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy 
    redirect_to user_posts_path(current_user) 
  end
  
  
   private
  
  def post_params
    params.require(:post).permit(:image, :title, :content, :is_draft)
  end
  
  
  
end
