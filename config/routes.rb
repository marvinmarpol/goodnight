Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth"

  # Follow/Unfollow Users
  resources :users, only: [] do
    member do
      post "follow", to: "follows#create"
      delete "unfollow", to: "follows#destroy"
    end
  end

  # Sleep Records
  resources :sleep_records, only: [ :index ] do
    collection do
      post "clock_in", to: "sleep_records#create"
      patch "clock_out", to: "sleep_records#update"
      get "friends", to: "followings#sleep_records"
    end
  end

  # Health Check
  get "up", to: "rails/health#show", as: :rails_health_check
end
