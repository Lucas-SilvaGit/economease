# frozen_string_literal: true

module Transactions
  class SearchService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def ransack_query
      ransack_scope
    end

    def call
      ransack_scope.result(distinct: true).for_user(@user)
    end

    private

    def ransack_scope
      Transaction.ransack(@params[:q])
    end
  end
end
