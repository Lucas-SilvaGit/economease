# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :set_query, only: :index

  def index
    @transactions = @query.for_user(current_user)
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
      :due_date, :status, :account_id, :category_id
    )
  end

  def valid_account?(account)
    account && account.user_id == current_user.id
  end

  def set_query
    @query = Transaction.all
    @query = @query.filter_by_description(params[:description]) if params[:description].present?
    @query = @query.filter_by_transaction_type(params[:transaction_type]) if params[:transaction_type].present?
    if params[:due_date_start].present? && params[:due_date_end].present?
      start_date = DateTime.parse(params[:due_date_start])
      end_date = DateTime.parse(params[:due_date_end])
      @query = @query.filter_by_due_date_range(start_date, end_date)
    end
    @query = @query.filter_by_account_id(params[:account_id]) if params[:account_id].present?
    @query = @query.filter_by_category_id(params[:category_id]) if params[:category_id].present?
    @query = @query.filter_by_status(params[:status]) if params[:status].present?
  end
end
