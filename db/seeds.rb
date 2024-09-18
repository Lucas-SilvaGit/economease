# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# create a default user
User.create!(
  first_name: 'John',
  last_name: 'Doe',
  email: 'admin@admin.com',
  password: '123456',
  password_confirmation: '123456'
)
puts "Default user created successfully"

# Create a new account for the default user
2.times do |i|
Account.create!(
  name: "Default Account #{i}",
  user_id: User.first.id
)
end

puts "Account Default created successfuly"

# Creating categories
categories = [
  'Alimentação',
  'Transporte',
  'Moradia',
  'Educação',
  'Saúde',
  'Lazer',
  'Investimentos',
  'Roupas',
  'Tecnologia',
  'Serviços Públicos',
  'Outros'
]

User.find_each do |user|
  categories.each do |name|
    Category.find_or_create_by(
      name: name,
      user_id: user.id
    )
  end
end

puts "Categories created successfuly"

#Creating transactions

# Create a new transaction for the default account
20.times do |i|
  Transaction.create!(
    amount: Faker::Number.decimal(l_digits: 2),
    transaction_type: ['income', 'expense'].sample,
    description: Faker::Lorem.sentence,
    account_id: Account.all.sample.id,
    category_id: Category.all.sample.id,
    due_date: Faker::Date.forward(days: 30),
    status: ['pending', 'completed'].sample
  )
end
puts "Transactions created successfuly"
