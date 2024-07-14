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

    ActiveRecord::Base.transaction do
      begin
        if sufficient_balance?
          @transaction.save!
          CalculatedBalance.new(@transaction.account).call
          redirect_to transactions_path, notice: "Transaction was successfully created."
        else
          redirect_to transactions_path, alert: "Saldo insuficiente"
          raise ActiveRecord::Rollback
        end
      rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = e.message
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      begin
        if sufficient_balance?
          @transaction.update!(transaction_params)
          CalculatedBalance.new(@transaction.account).call
          redirect_to transactions_path, notice: "Transaction was successfully updated.", status: :see_other
        else
          redirect_to transctions_path, alert: "Saldo insuficiente"
          raise ActiveRecord::Rollback
        end
      rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = e.message
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        @transaction.destroy!
        CalculatedBalance.new(@transaction.account).call
        redirect_to transactions_url, notice: "Transaction was successfully destroyed.", status: :see_other
      rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = e.message
        redirect_to transactions_url, alert: "Could not destroy the transaction."
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def sufficient_balance?
    return true if @transaction.transaction_type == "income"
    return true if @transaction.transaction_type == "expense" && @transaction.status != "completed"
    @transaction.account.balance >= @transaction.amount
  end

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
