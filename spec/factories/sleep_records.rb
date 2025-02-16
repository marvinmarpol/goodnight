FactoryBot.define do
  factory :sleep_record do
    user { nil }
    clock_in { "2025-02-16 14:03:27" }
    clock_out { "2025-02-16 14:03:27" }
    duration { 1 }
  end
end
