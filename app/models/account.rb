# frozen_string_literal: true

class Account < ApplicationRecord
  include DefaultUuid

  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_default_balance

  def partial_balance
    transactions.income.sum(:amount) - transactions.expense.sum(:amount)
  end

  def update_balance
    CalculatedBalance.new(self).calculate_balance
  end

  private

  def set_default_balance
    self.balance ||= 0
  end
end
