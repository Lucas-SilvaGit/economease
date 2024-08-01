# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:transaction_type) }
    it { should validate_presence_of(:description) }
  end

  context "associations" do
    it { should belong_to(:account) }
  end

  context "enums" do
    # it { should define_enum_for(:transaction_type).with_values(income: "income", expense: "expense") }
    # it { should define_enum_for(:status).with_values(pending: "pending", completed: "completed") }

    it { should define_enum_for(:transaction_type).with_values(income: "income", expense: "expense").backed_by_column_of_type(:string) }
    it { should define_enum_for(:status).with_values(pending: "pending", completed: "completed").backed_by_column_of_type(:string) }
  end

  context "scopes" do
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }
    let!(:income_transaction) { create(:transaction, account: account, transaction_type: "income") }
    let!(:expense_transaction) { create(:transaction, account: account, transaction_type: "expense") }

    it "returns only income transactions" do
      expect(Transaction.income).to include(income_transaction)
      expect(Transaction.income).not_to include(expense_transaction)
    end

    it "returns only expense transactions" do
      expect(Transaction.expense).to include(expense_transaction)
      expect(Transaction.expense).not_to include(income_transaction)
    end
  end
end
