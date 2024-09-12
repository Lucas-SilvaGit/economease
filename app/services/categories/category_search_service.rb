# frozen_string_literal: true

module Categories
  class CategorySearchService
    def initialize(user)
      @user = user
    end

    def call
      Category.joins(:transactions).where(transactions: { account_id: @user.accounts.ids }).distinct
    end
  end
end
