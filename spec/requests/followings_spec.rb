require 'rails_helper'

RSpec.describe "SleepRecords - Followings API", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let!(:sleep_record) { create(:sleep_record, user: other_user, clock_in: 2.days.ago, duration: 7.hours) }

  before { user.following_relationships.create!(following: other_user) }

  describe "GET /sleep_records/friends" do
    context "when a user want to see sleep records of other user which he/she follows" do
      it "retrieves sleep records of following users" do
        get '/sleep_records/friends', headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"]).not_to be_empty
      end
    end
  end
end
