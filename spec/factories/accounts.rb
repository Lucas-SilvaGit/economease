# spec/factories/accounts.rb
FactoryBot.define do
  factory :account do
    name { "Conta Corrente #{Time.now.to_i}" }
    balance { 0 }
    user
  end
end
