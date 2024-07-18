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
        @transaction.errors.add(:base, "Insufficient balance")
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def update_balance
    CalculatedBalance.new(@transaction.account).call
  end
end
