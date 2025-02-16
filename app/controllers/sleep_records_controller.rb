class SleepRecordsController < ApplicationController
  before_action :authenticate_user!

  def create
    # ensure user does not have an active clock-in session
    existing_record = current_user.sleep_records.where(clock_out: nil).lock("FOR UPDATE").first

    if existing_record
      render json: { status: :bad_request, error: "clock-out process required for current active clock-in session" }, status: :bad_request
    else
      sleep_record = current_user.sleep_records.create!(clock_in: Time.current)
      render json: sleep_record, status: :created
    end
  end

  def update
    # retrieve active clock-in session and lock it for update
    sleep_record = current_user.sleep_records.where(clock_out: nil).order(created_at: :desc).lock("FOR UPDATE").first
    if sleep_record.nil?
      return render json: { status: :not_found, error:  "no active clock-in session found"  }, status: :not_found
    end

    sleep_record.update!(clock_out: Time.current, duration: Time.current - sleep_record.clock_in)

    render json: sleep_record, status: :ok
  end

  def index
    pagy, sleep_records = pagy(current_user.sleep_records.order(created_at: :desc))
    render json: { sleep_records: sleep_records,
      pagination: {
        total: pagy.count,
        current_page: pagy.page,
        limit_per_page: pagy.limit
      }
    }
  end
end
