# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :load_accounts, only: :index
  before_action :load_categories, only: :index

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = Transactions::SearchService.new(params: params[:q], user: current_user).call
  end

  def show; end

  def new
    @transaction = Transaction.new(
      account_id: params[:account_id],
      transaction_type: params[:transaction_type]
    )
  end

  def edit; end

  def create
    @transaction = Transaction.new(transaction_params)

    unless valid_account?(@transaction.account)
      @transaction.errors.add(:account, t("transactions.errors.invalid"))
      return render :new, status: :unprocessable_entity
    end

    if transaction_processor.process_transaction(:save!)
      redirect_to transactions_path, notice: t("transactions.notice.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @transaction.assign_attributes(transaction_params)

    unless valid_account?(@transaction.account)
      @transaction.errors.add(:account, t("transactions.errors.invalid"))
      return render :edit, status: :unprocessable_entity
    end

    if transaction_processor.process_transaction(:save!)
      redirect_to transactions_path, notice: t("transactions.notice.edit")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @transaction.destroy!
      Accounts::UpdateBalanceService.new(@transaction.account).call
    end
    redirect_to transactions_url, notice: t("transactions.notice.destroy")
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
    account && current_user.accounts.ids.include?(account.id)
  end

  def load_accounts
    @accounts = current_user.accounts
  end

  def load_categories
    @categories = current_user.categories
  end

  def transaction_processor
    @transaction_processor ||= Transactions::ProcessorService.new(@transaction)
  end
end
