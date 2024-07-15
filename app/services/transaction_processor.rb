class TransactionProcessor
  def initialize(transaction)
    @transaction = transaction
  end

  def process_transaction(save_method)
    ActiveRecord::Base.transaction do
      if SufficientBalanceService.new(@transaction).call
        @transaction.send(save_method)
        update_balance
      else
        raise ActiveRecord::Rollback, "Insufficient balance"
      end
    end
  end

  private

  def update_balance
    CalculatedBalance.new(@transaction.account).call
  end
end
