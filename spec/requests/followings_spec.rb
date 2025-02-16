require 'rails_helper'

RSpec.describe "Followings", type: :request do
  describe "GET /sleep_records" do
    it "returns http success" do
      get "/followings/sleep_records"
      expect(response).to have_http_status(:success)
    end
  end

end
