class Transaction < ApplicationRecord
  include DefaultUuid

  belongs_to :account
  belongs_to :category

  validates :transaction_type, :description, :date, :status, presence: true
  validates :amount, numericality: { greater_than: 0 }, presence: true

  enum transaction_type: { income: "income", expense: "expense" }
  enum status: { pending: "pending", completed: "completed" }
end
