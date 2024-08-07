# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[show edit update destroy]

  def index
    @accounts = current_user.accounts.order(:created_at)
  end

  def show; end

  def new
    @account = Account.new
  end

  def edit; end

  def create
    @account = current_user.accounts.new(account_params)

    if @account.save
      redirect_to accounts_path, notice: I18n.t("views.account.notice.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: I18n.t("views.account.notice.edit"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy!
    redirect_to accounts_url, notice:  I18n.t("views.account.notice.destroy"), status: :see_other
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :balance)
  end
end
