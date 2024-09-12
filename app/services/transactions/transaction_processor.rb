# frozen_string_literal: true

module Transactions
  class TransactionProcessor
    def initialize(transaction)
      @transaction = transaction
    end

    def process_transaction(save_method)
      ActiveRecord::Base.transaction do
        if Accounts::SufficientBalanceService.new(@transaction).call
          @transaction.send(save_method)
          update_balance
        else
          @transaction.errors.add(:base, I18n.t("activerecord.errors.balance.insufficient"))
          raise ActiveRecord::Rollback
        end
      end
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    def update_balance
      Accounts::CalculatedBalance.new(@transaction.account).call
    end
  end
end
