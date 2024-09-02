# frozen_string_literal: true

class TransactionReminderJob < ApplicationJob
  queue_as :mailers

  def perform
    transactions = Transaction.where(due_date: 3.days.from_now.to_date)
    transactions.each do |transaction|
      TransactionMailer.transaction_reminder(transaction).deliver_later
    end
  end
end
