class FollowingsController < ApplicationController
  before_action :authenticate_user!

  def sleep_records
    pagy, sleep_records = pagy(
      SleepRecord.joins(user: :followers)
        .where(users: { id: current_user.followings.pluck(:id) })
        .where("clock_in >= ?", 1.week.ago)
        .order(duration: :desc)
    )

    render json: { data: sleep_records,
      pagination: {
        total: pagy.count,
        current_page: pagy.page,
        limit_per_page: pagy.limit
      }
    }
  end
end
