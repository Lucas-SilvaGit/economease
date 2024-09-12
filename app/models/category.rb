# frozen_string_literal: true

class Category < ApplicationRecord
  include DefaultUuid

  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true

  scope :by_user_accounts, lambda { |user|
    joins(:transactions)
      .where(transactions: { account_id: user.accounts.ids })
      .distinct
  }
end
