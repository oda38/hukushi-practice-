class Admins::AnnouncementsController < ApplicationController
   before_action :authenticate_admin!
  
  
  def index
    @announcement = Announcement.new
    @announcements = Announcement.order(created_at: :desc).page(params[:page]).per(4)
  end
  
  def create
    @announcement = Announcement.new(announcement_params)
    if @announcement.save
     flash[:notice] = "公開しました"
     redirect_to admins_announcements_path
    else
     @announcements = Announcement.order(created_at: :desc).page(params[:page]).per(4)
     render :index
    end
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end
  
  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params)
     flash[:notice] = "更新しました" 
     redirect_to admins_announcement_path
    else
     @announcements = Announcement.all
     render :edit
    end
  end
  
  def destroy
    @announcement = Announcement.find(params[:id])
    if @announcement.destroy
     redirect_to admin_announcements_path
    else
     render :edit 
    end
  end
  
  
  def announcement_params
    params.require(:announcement).permit(:title, :content, :announcement_image)
  end
  
  
end
