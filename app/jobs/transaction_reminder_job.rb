# frozen_string_literal: true

class TransactionReminderJob < ApplicationJob
  queue_as :mailers

  def perform(transaction)
    return unless transaction.due_date == 3.days.from_now.to_date

    TransactionMailer.transaction_reminder(transaction).deliver_later
  end
end
