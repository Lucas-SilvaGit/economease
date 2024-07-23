class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = Transaction.joins(:account).where(accounts: { user_id: current_user.id })
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

    unless valid_account?(@transaction.account)
      flash.now[:alert] = "Invalid account"
      return render :new, status: :unprocessable_entity
    end

    processor = TransactionProcessor.new(@transaction)

    if processor.process_transaction(:save!)
      redirect_to transactions_path, notice: "Transaction created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @transaction.assign_attributes(transaction_params)
    processor = TransactionProcessor.new(@transaction)

    if processor.process_transaction(:save!)
      redirect_to transactions_path, notice: "Transaction updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @transaction.destroy!
      CalculatedBalance.new(@transaction.account).call
    end
    redirect_to transactions_url, notice: "Transaction deleted successfully"
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

  def valid_account?(account)
    account && account.user_id == current_user.id
  end
end
