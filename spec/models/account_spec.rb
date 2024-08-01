require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) { create(:user) }
  let(:account) { build(:account, user: user) }

  describe "validations" do
    context "when name is not present" do
      before { account.name = nil }

      it "is not valid" do
        is_expected.not_to be_valid
      end

      it "returns an error message" do
        account.valid?

        expect(account.errors[:name]).to include("can't be blank")
      end
    end

    context "whe name is present" do
      before { account.name = "Savings" }

      it "is valid" do
        expect(account).to be_valid
      end

      it "does not return an error message" do
        account.valid?

        expect(account.errors[:name]).to be_empty
      end
    end
  end

  describe "associations" do
    context "has associations" do
      it "belongs to a user" do
        expect(account.user).to eq(user)
      end
    end
  end

  describe "creating an account" do
    context "with valid parameters" do
      it "creates a new account successfully" do
        expect(account).to be_valid

        account.save

        expect(Account.last).to eq(account)
      end
    end

    context "with invalid parameters" do
      it "does not create an account without a name" do
        account.name = nil

        is_expected.not_to be_valid
      end

      it "does not create an account with a negative balance" do
        account.balance = -100

        is_expected.not_to be_valid
      end

      it "does not create an account with a non-numeric balance" do
        account.balance = "one hundred"

        is_expected.not_to be_valid
      end
    end
  end

  describe "calculating partial balance" do
    let(:transaction1) { create(:transaction, account: account, amount: transaction_amount1, transaction_type: transaction_type1) }
    let(:transaction2) { create(:transaction, account: account, amount: transaction_amount2, transaction_type: transaction_type2) }

    before do
      transaction1
      transaction2
    end

    context "when calculations are correct" do
      let(:transaction_amount1) { 1000 }
      let(:transaction_type1) { "income" }
      let(:transaction_amount2) { 300 }
      let(:transaction_type2) { "expense" }

      it "calculates the partial balance correctly" do
        partial_balance = account.partial_balance

        expect(partial_balance).to eq(700)
      end
    end

    context "when calculations are incorrect" do
      let(:transaction_amount1) { 800 }
      let(:transaction_type1) { "income" }
      let(:transaction_amount2) { 300 }
      let(:transaction_type2) { "expense" }

      it "calculates the partial balance incorrectly" do
        partial_balance = account.partial_balance

        expect(partial_balance).not_to eq(700)
      end
    end
  end

  describe "callbacks" do
    let(:new_account) { build(:account, name: "Checking", user: user, balance: nil) }

    before do
      new_account.valid?
    end

    it "sets default balance before validation" do
      expect(new_account.balance).to eq(0)
    end
  end
end
