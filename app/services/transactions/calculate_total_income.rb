# frozen_string_literal: true

module Transactions
  class CalculateTotalIncome
    def initialize(account_id)
      @account_id = account_id
    end

    def call
      calculate_income
    end

    private

    def calculate_income
      Transaction.where(account_id: @account_id, transaction_type: "income", status: "completed").sum(:amount)
    end
  end
end
