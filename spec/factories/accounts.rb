# spec/factories/accounts.rb
FactoryBot.define do
  factory :account do
    name { "Conta Corrente" }
    balance { 1000.0 }
    association :user
  end
end