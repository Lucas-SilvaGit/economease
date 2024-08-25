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
  scope :for_user, ->(user) { joins(:account).where(accounts: { user_id: user.id }).order(due_date: :desc) }
  scope :filter_by_description, ->(description) { where("description LIKE ?", "%#{description}%") }
  scope :filter_by_transaction_type, ->(transaction_type) { where(transaction_type:) }
  scope :filter_by_due_date_range, ->(start_date, end_date) { where(due_date: start_date..end_date) }
  scope :filter_by_account_id, ->(account_id) { where(account_id:) }
  scope :filter_by_category_id, ->(category_id) { where(category_id:) }
  scope :filter_by_status, ->(status) { where(status:) }
end
