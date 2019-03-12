class LikesController < ApplicationController
  before_action :authenticate_user
  
  def create
    @like = Like.new(post_id: params[:post_id], user_id: @current_user.id)
    @like.save
    redirect_to("/posts/#{params[:post_id]}")
  end
  
  def destroy
    @like = Like.find_by(post_id: params[:post_id], user_id: @current_user.id)
    @like.destroy
    redirect_to("/posts/#{params[:post_id]}")
  end
end