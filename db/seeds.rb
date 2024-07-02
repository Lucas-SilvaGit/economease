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

# Create a new account for the default user
10.times do |i|
Account.create!(
  name: "Default Account #{i}",
  balance: Faker::Number.decimal(l_digits: 2),
  user_id: User.first.id
)
end

# Categorias para um sistema de controle financeiro pessoal
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

# Itera sobre as categorias e as cria no banco de dados, se ainda não existirem
categories.each do |name|
  Category.find_or_create_by(name: name)
end

puts "Categorias criadas com sucesso!"