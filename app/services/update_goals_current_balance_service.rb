# frozen_string_literal: true

class UpdateGoalsCurrentBalanceService
  def initialize(user)
    @user = user
  end

  def call
    total_balance = @user.total_account_balance
    @user.goals.find_each do |goal|
      goal.update(current_amount: total_balance)
    end
  end

  def calculate_current_balance
    @user.total_account_balance
  end
end
