# frozen_string_literal: true

module Accounts
  class UpdateBalanceService
    def initialize(account)
      @account = account
    end

    def call
      calculate_balance
    end

    def calculate_balance
      total_income = Transactions::CalculateTotalIncomeService.new(@account.id).call

      total_expense = Transactions::CalculateTotalExpenseService.new(@account.id).call

      calculated_balance = total_income - total_expense

      @account.update!(balance: calculated_balance)
    end
  end
end
