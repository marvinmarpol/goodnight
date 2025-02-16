class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_to_follow = User.find(params[:id])

    if current_user == user_to_follow
      return render json: { status: :bad_request, error: "cannot follow yourself" }, status: :bad_request
    end

    begin
      follow = current_user.following_relationships.create!(following: user_to_follow)
      render json: follow, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: :bad_request, errors: e.record.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
  end
end
