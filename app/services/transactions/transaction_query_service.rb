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
      predefined_periods = {
        "today" => -> { [Time.zone.today, Time.zone.today] },
        "yesterday" => -> { [Time.zone.yesterday, Time.zone.yesterday] },
        "this_week" => -> { [Time.zone.today.beginning_of_week, Time.zone.today.end_of_week] },
        "last_week" => -> { [1.week.ago.beginning_of_week, 1.week.ago.end_of_week] },
        "last_7_days" => -> { [7.days.ago.to_date, Time.zone.today] },
        "current_month" => -> { [Time.zone.today.beginning_of_month, Time.zone.today.end_of_month] },
        "last_30_days" => -> { [30.days.ago.to_date, Time.zone.today] },
        "current_year" => -> { [Time.zone.today.beginning_of_year, Time.zone.today.end_of_year] },
        "last_3_months" => -> { [3.months.ago.beginning_of_month, Time.zone.today] },
        "last_6_months" => -> { [6.months.ago.beginning_of_month, Time.zone.today] },
        "last_month" => -> { [1.month.ago.beginning_of_month, 1.month.ago.end_of_month] }
      }

      if @params[:predefined_period].present? && predefined_periods.key?(@params[:predefined_period])
        start_date, end_date = predefined_periods[@params[:predefined_period]].call
        query = query.where(due_date: start_date..end_date)
      end

      query
    end
  end
end
