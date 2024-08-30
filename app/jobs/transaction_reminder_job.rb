# frozen_string_literal: true

class TransactionReminderJob < ApplicationJob
  queue_as :mailers

  def perform(transaction)
    TransactionMailer.transaction_reminder(transaction).deliver_now
  end
end
