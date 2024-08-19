# frozen_string_literal: true

module Transactions
  class TransactionQueryService
    def initialize(params)
      @params = params
    end

    def call
      query = Transaction.all
      query = query.filter_by_description(@params[:description]) if @params[:description].present?
      query = query.filter_by_transaction_type(@params[:transaction_type]) if @params[:transaction_type].present?
      query = apply_due_date_filter(query)
      query = query.filter_by_account_id(@params[:account_id]) if @params[:account_id].present?
      query = query.filter_by_category_id(@params[:category_id]) if @params[:category_id].present?
      query = query.filter_by_status(@params[:status]) if @params[:status].present?
      query
    end

    private

    def apply_due_date_filter(query)
      if @params[:due_date_start].present? && @params[:due_date_end].present?
        start_date = DateTime.parse(@params[:due_date_start])
        end_date = DateTime.parse(@params[:due_date_end])
        query = query.filter_by_due_date_range(start_date, end_date)
      else
        start_date = Date.today - 30.days
        end_date = Date.today
        query = query.where(due_date: start_date..end_date)
      end
      query
    end
  end
end
