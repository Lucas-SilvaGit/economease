# frozen_string_literal: true

module Accounts
  class SufficientBalanceService
    def initialize(transaction)
      @transaction = transaction
    end

    def call
      return true if income_transaction?
      return true if expense_transaction_pending?

      sufficcient_balance?
    end

    private

    def income_transaction?
      @transaction.transaction_type == "income"
    end

    def expense_transaction_pending?
      @transaction.transaction_type == "expense" && @transaction.status != "completed"
    end

    def sufficcient_balance?
      @transaction.account.balance >= @transaction.amount
    end
  end
end
