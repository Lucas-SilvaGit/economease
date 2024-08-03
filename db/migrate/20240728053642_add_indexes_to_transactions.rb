# frozen_string_literal: true

class AddIndexesToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_index :transactions, :transaction_type
    add_index :transactions, :date
  end
end
