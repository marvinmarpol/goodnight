require 'rails_helper'

RSpec.describe "SleepRecords", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/sleep_records/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/sleep_records/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/sleep_records/index"
      expect(response).to have_http_status(:success)
    end
  end

end
