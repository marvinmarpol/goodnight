class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      user_to_follow = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render json: { status: :not_found, error: "user not found" }, status: :not_found
    end

    if current_user == user_to_follow
      return render json: { status: :bad_request, error: "cannot follow yourself" }, status: :bad_request
    end

    begin
      follow = current_user.following_relationships.create!(following: user_to_follow)
      render json: follow, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: :bad_request, error: e.record.errors.full_messages[0] }, status: :bad_request
    end
  end

  def destroy
    begin
      user_to_unfollow = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render json: { status: :not_found, error: "user not found" }, status: :not_found
    end

    if current_user.following_relationships.exists?(following: user_to_unfollow)
      unfollow = current_user.following_relationships.find_by(following: user_to_unfollow).destroy!
      render json: unfollow, status: :ok
    else
      render json: { status: :bad_request, error: "you are not following this user" }, status: :bad_request
    end
  end
end
