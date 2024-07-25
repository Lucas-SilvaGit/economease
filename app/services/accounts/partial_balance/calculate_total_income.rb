# frozen_string_literal: true

module Accounts
  module PartialBalance
    class CalculateTotalIncome
      def initialize(account_id)
        @account_id = account_id
      end

      def call
        calculate_income
      end

      private

      def calculate_income
        Transaction.where(account_id: @account_id, transaction_type: "income").sum(:amount)
      end
    end
  end
end
