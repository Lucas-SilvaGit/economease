# frozen_string_literal: true

module Transactions
  class CalculateTotalService
    def initialize(account_id, transaction_type)
      @account_id = account_id
      @transaction_type = transaction_type
    end

    def call
      calculate_total
    end

    private

    def calculate_total
      Transaction.where(account_id: @account_id, transaction_type: @transaction_type, status: "completed").sum(:amount)
    end
  end
end
