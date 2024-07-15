# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    email { "testeemailunique#{Time.now.to_f}@outlook.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
