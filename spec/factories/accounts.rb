# spec/factories/accounts.rb
FactoryBot.define do
  factory :account do
    name { "Conta Corrente" }
    balance { 0 }
    user
  end
end
