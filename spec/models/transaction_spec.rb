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
    it { should define_enum_for(:transaction_type).with_values(income: "income", expense: "expense").backed_by_column_of_type(:string) }
    it { should define_enum_for(:status).with_values(pending: "pending", completed: "completed").backed_by_column_of_type(:string) }
  end

  describe "scopes" do
    context "when checking scope definitions" do
      it "should have a scope named income" do
        expect(Transaction).to respond_to(:income)
      end

      it "should have a scope named expense" do
        expect(Transaction).to respond_to(:expense)
      end

      it "should have a scope named for_user" do
        expect(Transaction).to respond_to(:for_user)
      end
    end

    context "when using the income scope" do
      it "returns only income transactions" do
        income_transaction = create(:transaction, transaction_type: "income")
        expense_transaction = create(:transaction, transaction_type: "expense")

        expect(Transaction.income).not_to include(expense_transaction)
      end
    end

    context "when using the expense scope" do
      it "returns only expense transactions" do
        income_transaction = create(:transaction, transaction_type: "income")
        expense_transaction = create(:transaction, transaction_type: "expense")

        expect(Transaction.expense).not_to include(income_transaction)
      end
    end

    context "when using the for_user scope" do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:user_account) { create(:account, user: user) }
      let(:another_account) { create(:account, user: another_user) }

      it "returns transactions for the specified user" do
        user_transaction = create(:transaction, account: user_account)
        another_user_transaction = create(:transaction, account: another_account)

        expect(Transaction.for_user(user)).not_to include(another_user_transaction)
      end
    end
  end
end
