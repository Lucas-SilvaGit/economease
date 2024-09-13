# frozen_string_literal: true

module Accounts
  class UpdateBalanceService
    def initialize(account)
      @account = account
    end

    def call
      calculate_balance
    rescue StandardError => e
      handle_error(e)
    end

    private

    def calculate_balance
      total_income = Transactions::CalculateTotalIncomeService.new(@account.id).call
      total_expense = Transactions::CalculateTotalExpenseService.new(@account.id).call
      calculated_balance = total_income - total_expense

      @account.update!(balance: calculated_balance)
    end

    def handle_error(exception)
      Rails.logger.error("Failed to update balance: #{exception.message}")
      I18n.t("activerecord.errors.balance.update_failed")
    end
  end
end
