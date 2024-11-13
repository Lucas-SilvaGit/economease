# frozen_string_literal: true

module Transactions
  class ProcessorService
    def initialize(transaction)
      @transaction = transaction
    end

    def process_transaction(save_method)
      return handle_insufficient_balance unless sufficient_balance?

      perform_transaction(save_method)
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    def sufficient_balance?
      Accounts::SufficientBalanceService.new(@transaction).call
    end

    def perform_transaction(save_method)
      ActiveRecord::Base.transaction do
        @transaction.send(save_method)
        update_balance
      end
    end

    def handle_insufficient_balance
      @transaction.errors.add(:base, I18n.t("activerecord.errors.balance.insufficient"))
      false
    end

    def update_balance
      Accounts::UpdateBalanceService.new(@transaction.account).call
    end
  end
end
