# frozen_string_literal: true

module Transactions
  class TransactionSearchService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def ransack_query
      Transaction.ransack(@params[:q])
    end

    def call
      Transaction.ransack(@params[:q]).result(distinct: true).for_user(@user)
    end
  end
end
