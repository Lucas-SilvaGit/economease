# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = Transaction.all
  end

  def show
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      @transaction.account.calculate_balance(@transaction)
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Transaction was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy!
    redirect_to transactions_url, notice: "Transaction was successfully destroyed.", status: :see_other
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :amount, :transaction_type, :description,
      :date, :status, :account_id, :category_id
    )
  end
end
