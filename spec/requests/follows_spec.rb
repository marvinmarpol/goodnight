require 'rails_helper'

RSpec.describe "Follows API", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe "POST /users/:id/follow" do
    context "when a user successfully follows other user" do
      it "creates a new record" do
        post "/users/#{other_user.id}/follow", headers: auth_headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["follower_id"]).not_to be_nil
        expect(JSON.parse(response.body)["following_id"]).not_to be_nil
      end
    end

    context "when a user follows him/her self" do
      it "returns an error" do
        post "/users/#{user.id}/follow", headers: auth_headers
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("cannot follow yourself")
      end
    end
  end

  describe 'DELETE /users/:id/unfollow' do
    context "when a user successfully unfollows other user" do
      it "delete the current the corresponding record" do
        user.following_relationships.create!(following: other_user)
        delete "/users/#{other_user.id}/unfollow", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["follower_id"]).not_to be_nil
        expect(JSON.parse(response.body)["following_id"]).not_to be_nil
      end
    end

    context "when unfollows user which relation is non-existant" do
      it "returns an error with status bad_request" do
        delete "/users/#{user.id}/unfollow", headers: auth_headers
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("you are not following this user")
      end
    end

    context "when a user unfollows him/her self" do
      it "returns an error with status not_found" do
        delete "/users/9999/unfollow", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("user not found")
      end
    end
  end
end
