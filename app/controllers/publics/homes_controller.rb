class Publics::HomesController < ApplicationController
  def top
    @announcements = Announcement.order(created_at: :desc).first(3)
  end
  
  def announcements
    @announcements = Announcement.order(created_at: :desc).page(params[:page]).per(3)
  end
  
end
