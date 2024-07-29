class RenameDateInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :date, :due_date
  end
end
