# frozen_string_literal: true

module Transactions
  class TransactionSearchService
    attr_reader :ransack_query, :result

    def initialize(user, params)
      @user = user
      @params = params
      @ransack_query = Transaction.ransack(@params[:q])
      @result = @ransack_query.result(distinct: true).for_user(@user)
    end
  end
end
