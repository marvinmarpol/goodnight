class FollowingsController < ApplicationController
  before_action :authenticate_user!

  def sleep_records
    cache_key = "friends_sleep_records_#{current_user.id}"

    sleep_records_cache = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      SleepRecord.joins(user: :followers)
        .where(users: { id: current_user.followings.pluck(:id) })
        .where("clock_in >= ?", 1.week.ago)
        .order(duration: :desc)
    end

    pagy, sleep_records = pagy(sleep_records_cache)

    render json: { data: sleep_records,
      pagination: {
        total: pagy.count,
        current_page: pagy.page,
        limit_per_page: pagy.limit
      }
    }
  end
end
