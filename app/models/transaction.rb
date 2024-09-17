# frozen_string_literal: true

class Transaction < ApplicationRecord
  include DefaultUuid

  belongs_to :account
  belongs_to :category

  has_one_attached :voucher

  validates :transaction_type, :description, :due_date, :status, presence: true
  validates :amount, numericality: { greater_than: 0 }, presence: true

  enum transaction_type: { income: "income", expense: "expense" }
  enum status: { pending: "pending", completed: "completed" }

  scope :income, -> { where(transaction_type: "income") }
  scope :expense, -> { where(transaction_type: "expense") }
  scope :for_user, ->(user) { joins(:account).where(accounts: { user_id: user.id })}
  scope :completed, -> { where(status: "completed") }
end
