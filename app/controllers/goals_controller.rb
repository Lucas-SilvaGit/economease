# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: %i[show edit update destroy]

  def index
    @goals = current_user.goals
  end

  def show
  end

  def new
    @goal = Goal.new
  end

  def edit
  end

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      redirect_to goals_path, notice: "Goal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_path, notice: "Goal was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy!
    redirect_to goals_url, notice: "Goal was successfully destroyed.", status: :see_other
  end

  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:name, :target_amount, :current_amount, :target_date, :saved_value)
  end
end
