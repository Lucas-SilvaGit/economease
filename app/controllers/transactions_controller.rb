# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result(distinct: true).for_user(current_user)
    @accounts = current_user.accounts
    @categories = Category.joins(:transactions).where(transactions: { account_id: current_user.accounts.ids }).distinct
  end

  def show; end

  def new
    @transaction = Transaction.new
  end

  def edit; end

  def create
    @transaction = Transaction.new(transaction_params)

    unless valid_account?(@transaction.account)
      @transaction.errors.add(:account, t("views.transaction.errors.invalid"))
      return render :new, status: :unprocessable_entity
    end

    processor = TransactionProcessor.new(@transaction)

    if processor.process_transaction(:save!)
      redirect_to transactions_path, notice: t("views.transaction.notice.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @transaction.assign_attributes(transaction_params)

    unless valid_account?(@transaction.account)
      @transaction.errors.add(:account, t("views.transaction.errors.invalid"))
      return render :edit, status: :unprocessable_entity
    end

    processor = TransactionProcessor.new(@transaction)

    if processor.process_transaction(:save!)
      redirect_to transactions_path, notice: t("views.transaction.notice.edit")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @transaction.destroy!
      CalculatedBalance.new(@transaction.account).call
    end
    redirect_to transactions_url, notice: t("views.transaction.notice.destroy")
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :amount, :transaction_type, :description,
      :due_date, :status, :account_id, :category_id,
      :voucher
    )
  end

  def valid_account?(account)
    account && account.user_id == current_user.id
  end
end
