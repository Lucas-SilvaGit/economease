class TransactionProcessor
  def initialize(transaction)
    @transaction = transaction
  end

  def create
    process_transaction(:save!)
  end

  def update(attributes)
    @transaction.assign_attributes(attributes)
    process_transaction(:save!)
  end

  def destroy
    ActiveRecord::Base.transaction do
      @transaction.destroy!
      update_balance
    end
  end

  private

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

  def update_balance
    CalculatedBalance.new(@transaction.account).call
  end
end
