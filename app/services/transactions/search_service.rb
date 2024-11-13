# frozen_string_literal: true

module Transactions
  class SearchService
    def initialize(params:, user:)
      @params = params
      @user = user
    end

    def call
      Transaction.ransack(@params).result(distinct: true).for_user(@user)
    end
  end
end
