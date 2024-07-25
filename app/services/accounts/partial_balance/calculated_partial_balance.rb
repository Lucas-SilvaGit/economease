# frozen_string_literal: true

module Accounts
  module PartialBalance
    class CalculatedPartialBalance
      def initialize(account)
        @account = account
      end

      def call
        calculate_partial_balance
      end

      private

      def calculate_partial_balance
        total_income = Accounts::PartialBalance::CalculateTotalIncome.new(@account.id).call
        total_expense = Accounts::PartialBalance::CalculateTotalExpense.new(@account.id).call
        total_income - total_expense
      end
    end
  end
end
