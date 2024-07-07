FactoryBot.define do
  factory :goal do
    name { "MyString" }
    target_amount { 1.5 }
    current_amount { 1.5 }
    target_date { "2024-07-07" }
    saved_value { 1.5 }
    user
  end
end
