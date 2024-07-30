require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'validations' do
    it 'validates presence of name' do
      account.name = nil
      expect(account).not_to be_valid
      expect(account.errors[:name]).to include("can't be blank")

      account.name = 'Savings'
      account.valid?
      expect(account.errors[:name]).to be_empty
    end

  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(account.user).to eq(user)
    end
  end

  describe 'creating an account' do
    context 'with valid parameters' do
      it 'creates a new account successfully' do
        account = build(:account, name: 'Savings', balance: 1000, user: user)
        expect(account).to be_valid
        account.save
        expect(Account.last).to eq(account)
      end
    end

    context 'with invalid parameters' do
      it 'does not create an account without a name' do
        account.name = nil
        expect(account).not_to be_valid
      end

      it 'does not create an account with a negative balance' do
        account.balance = -100
        expect(account).not_to be_valid
      end

      it 'does not create an account with a non-numeric balance' do
        account.balance = 'one hundred'
        expect(account).not_to be_valid
      end
    end
  end

  describe 'calculating partial balance' do
    context "should be a success" do
      it 'calculates the partial balance correctly' do
        transaction1 = create(:transaction, account: account, amount: 1000, transaction_type: 'income')
        transaction2 = create(:transaction, account: account, amount: 300, transaction_type: 'expense')

        partial_balance = account.partial_balance

        expect(partial_balance).to eq(700)
      end
    end

    context "should be a fail" do
      it 'calculate the partial balance incorrectly' do
        transaction1 = create(:transaction, account: account, amount: 800, transaction_type: 'income')
        transaction2 = create(:transaction, account: account, amount: 300, transaction_type: 'expense')

        partial_balance = account.partial_balance

        expect(partial_balance).not_to eq(700)
      end
    end
  end

  describe 'callbacks' do
    it 'sets default balance before validation' do
      new_account = build(:account, name: 'Checking', user: user, balance: nil)
      new_account.valid?
      expect(new_account.balance).to eq(0)
    end
  end
end
