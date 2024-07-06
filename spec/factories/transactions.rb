FactoryBot.define do
  factory :transaction do
    amount { 100.5 }
    transaction_type { "expense" }
    description { "MyString" }
    date { "2024-07-05 23:45:17" }
    status { "pending" }
    account
    category
  end
end
