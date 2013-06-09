class MyFeedsController < ApplicationController
  
  before_filter :authenticate_user!, :allowed?
  
  def create
    @my_feed = MyFeed.new(params[:my_feed])
    flag = true
    exists = true
    if @my_feed.valid?
      feed = Ref::Feed.where(app_url: @my_feed.app_url).first
      if feed.blank?
        feed = Ref::Feed.new(app_url: @my_feed.app_url)
        feed.save
        exists = false
      end
      @my_feed.feed_id = feed.id
      if @my_feed.create_and_save_self
        if exists
          Delayed::Job.enqueue Job::Dj2.new(@my_feed.id, current_user.id)
        end
        flag = false
        redirect_to user_path(current_user), flash: {notice: t("creation.success")}
      end
    end
    if flag 
      @home = true
      @tags = @user.tags
      @without_tags = MyFeed.without_tags(@user)
      @entries = MyEntry.read.by_user(@user).page(params[:page]).per(50)
      @total_subscriptions = @user.entries_count(nil, nil)
      render "users/show", flash: {error: t("creation.failure")}
    end
  end
  
  def destroy
    Delayed::Job.enqueue Job::Dj3.new(params[:id])
    redirect_to user_path(current_user), flash: {notice: "Unsubscribing you."}
  end
    
  def request_fetch
    Delayed::Job.enqueue Job::Dj1.new(@my_feed.feed.id)
    redirect_to user_path(current_user), flash: {notice: "Please wait while we refresh."}
  end
  
  private
  
  def allowed?
    @my_feed = MyFeed.find(params[:id]) if !params[:id].blank?
  end
  
end