# frozen_string_literal: true

class SufficientBalanceService
  def initialize(transaction)
    @transaction = transaction
  end

  def call
    return true if @transaction.transaction_type == "income"
    return true if @transaction.transaction_type == "expense" && @transaction.status != "completed"

    @transaction.account.balance.to_f >= @transaction.amount.to_f
  end
end
