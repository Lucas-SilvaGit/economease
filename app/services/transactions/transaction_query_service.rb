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
      if @params[:predefined_period].present?
        case @params[:predefined_period]
        when "today"
          start_date = Date.today
          end_date = Date.today
        when "yesterday"
          start_date = Date.yesterday
          end_date = Date.yesterday
        when "this_week"
          start_date = Date.today.beginning_of_week
          end_date = Date.today.end_of_week
        when "last_week"
          start_date = 1.week.ago.beginning_of_week
          end_date = 1.week.ago.end_of_week
        when "last_7_days"
          start_date = 7.days.ago.to_date
          end_date = Date.today
        when "current_month"
          start_date = Date.today.beginning_of_month
          end_date = Date.today.end_of_month
        when "last_30_days"
          start_date = 30.days.ago.to_date
          end_date = Date.today
        when "current_year"
          start_date = Date.today.beginning_of_year
          end_date = Date.today.end_of_year
        when "last_3_months"
          start_date = 3.months.ago.beginning_of_month
          end_date = Date.today
        when "last_6_months"
          start_date = 6.months.ago.beginning_of_month
          end_date = Date.today
        when "last_month"
          start_date = 1.month.ago.beginning_of_month
          end_date = 1.month.ago.end_of_month
        else
          start_date = Time.zone.today - 30.days
          end_date = Time.zone.today
        end
        query = query.where(due_date: start_date..end_date)
      elsif @params[:due_date_start].present? && @params[:due_date_end].present?
        start_date = DateTime.parse(@params[:due_date_start])
        end_date = DateTime.parse(@params[:due_date_end])
        query = query.filter_by_due_date_range(start_date, end_date)
      else
        start_date = Time.zone.today - 30.days
        end_date = Time.zone.today
        query = query.where(due_date: start_date..end_date)
      end
      query
    end
  end
end
