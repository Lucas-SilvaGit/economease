# frozen_string_literal: true

class Account < ApplicationRecord
  include DefaultUuid

  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_default_balance

  def calculate_balance(transaction)
    current_balance = balance || 0

    new_balance = if transaction.transaction_type == "income" && transaction.status == "completed"
                    current_balance + transaction.amount
                  elsif transaction.transaction_type == "expense" && transaction.status == "completed"
                    current_balance - transaction.amount
                  else
                    current_balance
                  end

    update(balance: new_balance)
  end

  def calculaate_balance_transaction_deletion(transaction)
    current_balance = balance || 0

    new_balance = if transaction.transaction_type == "income" && transaction.status == "completed"
                    current_balance - transaction.amount
                  elsif transaction.transaction_type == "expense" && transaction.status == "completed"
                    current_balance + transaction.amount
                  else
                    current_balance
                  end

    update(balance: new_balance)
  end

  private

  def set_default_balance
    self.balance ||= 0
  end
end
