# frozen_string_literal: true

module Accounts
  module PartialBalance
    class CalculateTotalExpense
      def initialize(account_id)
        @account_id = account_id
      end

      def call
        calculate_expenses
      end

      private

      def calculate_expenses
        Transaction.where(account_id: @account_id, transaction_type: "expense").sum(:amount)
      end
    end
  end
end
