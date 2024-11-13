# frozen_string_literal: true

module Accounts
  class UpdateBalanceService
    def initialize(account)
      @account = account
    end

    def call
      calculate_balance
    end

    private

    def calculate_balance
      total_income = Transactions::CalculateTotalService.new(@account.id, "income").call
      total_expense = Transactions::CalculateTotalService.new(@account.id, "expense").call
      calculated_balance = total_income - total_expense

      @account.update!(balance: calculated_balance)
    end
  end
end
