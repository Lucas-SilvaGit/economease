require "rails_helper"

RSpec.describe Account, type: :model do
  context "validations" do
    let(:user) { create(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id).with_message("já está em uso") }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }

    before do
      create(:account, user: user, name: "Test Account")
    end
  end

  context "associations" do
    it { should belong_to(:user) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  context "callbacks" do
    it "should set balance to 0 when creating a new account" do
      account = create(:account, balance: nil)

      expect(account.balance).to eq(0)
    end
  end

  describe "partial_balance" do
    let(:account) { create(:account) }
    let(:transaction1) { create(:transaction, account: account, amount: 1000, transaction_type: "income") }
    let(:transaction2) { create(:transaction, account: account, amount: 300, transaction_type: "expense") }

    before do
      transaction1
      transaction2
    end

    it "calculates the partial balance correctly" do
      partial_balance = account.partial_balance

      expect(partial_balance).to eq(700)
    end
  end
end
