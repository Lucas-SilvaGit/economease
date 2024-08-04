# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: %i[show edit update destroy]

  def index
    @goals = current_user.goals
  end

  def show; end

  def new
    @goal = Goal.new

    @current_balance = UpdateGoalsCurrentBalanceService.new(current_user).calculate_current_balance
  end

  def edit
    @current_balance = UpdateGoalsCurrentBalanceService.new(current_user).calculate_current_balance
  end

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      redirect_to goals_path, notice: I18n.t("goal.notice.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_path, notice: I18n.t("goal.notice.edit"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy!
    redirect_to goals_url, notice: I18n.t("goal.notice.destroy"), status: :see_other
  end

  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:name, :target_amount, :current_amount, :target_date, :saved_value)
  end
end
