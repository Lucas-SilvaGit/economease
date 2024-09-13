# frozen_string_literal: true

module Goals
  class UpdateCurrentBalanceService
    def initialize(user)
      @user = user
    end

    def call
      current_balance = calculate_current_balance
      @user.goals.find_each do |goal|
        goal.update(current_amount: current_balance)
      end
    end

    def calculate_current_balance
      @user.total_account_balance
    end
  end
end
