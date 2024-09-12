# frozen_string_literal: true

module Accounts
  class AccountSearchService
    def initialize(user)
      @user = user
    end

    def call
      @user.accounts
    end
  end
end
