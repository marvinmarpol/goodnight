require 'rails_helper'

RSpec.describe "SleepRecords API", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe "POST /sleep_records/clock_in" do
    context "when user has no active session" do
      it "creates a new sleep record" do
        post "/sleep_records/clock_in", headers: auth_headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["clock_in"]).not_to be_nil
      end
    end

    context "when user has an active session" do
      before { create(:sleep_record, user: user) }

      it "returns an error" do
        post "/sleep_records/clock_in", headers: auth_headers
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("clock-out process required for current active clock-in session")
      end
    end
  end

  describe "PATCH /sleep_records/clock_out" do
    context "when user has an active session" do
      let!(:sleep_record) { create(:sleep_record, user: user) }

      it "clocks out the sleep session" do
        patch "/sleep_records/clock_out", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["clock_out"]).not_to be_nil
      end
    end

    context "when no active session" do
      it "returns not found error" do
        patch "/sleep_records/clock_out", headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
