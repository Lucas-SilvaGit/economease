# frozen_string_literal: true

class CategorySearchService
  def initialize(user)
    @user = user
  end

  def call
    Category.joins(:transactions).where(transactions: { account_id: @user.accounts.ids }).distinct
  end
end
