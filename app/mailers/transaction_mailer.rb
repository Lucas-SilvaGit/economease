# frozen_string_literal: true

class TransactionMailer < ApplicationMailer
  default from: "no-reply@economease.com"

  def transaction_reminder(transaction)
    @transaction = transaction
    @user = @transaction.account.user
    mail(to: @user.email, subject: I18n.t("views.mailers.transaction_mailer.transaction_reminder.subject"))
  end
end
