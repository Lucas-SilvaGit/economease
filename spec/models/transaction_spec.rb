require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:category) { create(:category) }
  let(:transaction) { create(:transaction, account: account, category: category) }

  describe 'validations' do
    it 'validates presence of amount' do
      transaction.amount = nil
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("can't be blank")

      transaction.amount = 1000
      transaction.valid?
      expect(transaction.errors[:amount]).to be_empty
    end

    it 'validates numericality of amount' do
      transaction.amount = 'one hundred'
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include('is not a number')

      transaction.amount = 1000
      transaction.valid?
      expect(transaction.errors[:amount]).to be_empty
    end

    it 'validates presence of transaction_type' do
      transaction.transaction_type = nil
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include("can't be blank")

      transaction.transaction_type = 'expense'
      transaction.valid?
      expect(transaction.errors[:transaction_type]).to be_empty
    end

    it 'is valid with a pending status' do
      transaction = Transaction.new(
        status: 'pending',
        amount: 100.0,
        transaction_type: 'expense',
        description: 'Test Description',
        date: Date.today,
        account: create(:account, user: create(:user)),
        category: create(:category)
      )
      expect(transaction).to be_valid
    end

    it 'is valid with a completed status' do
      transaction = Transaction.new(
        status: 'completed',
        amount: 100.0,
        transaction_type: 'income',
        description: 'Test Description',
        date: Date.today,
        account: create(:account, user: create(:user)),
        category: create(:category)
      )
      expect(transaction).to be_valid
    end

    it 'is not valid without a status' do
      transaction = Transaction.new(status: nil)
      expect(transaction).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an account' do
      expect(transaction.account).to eq(account)
    end

    it 'belongs to a category' do
      expect(transaction.category).to eq(category)
    end
  end

  describe 'creating a transaction' do
    context 'with valid parameters' do
      it 'creates a new transaction successfully' do
        transaction = build(:transaction, amount: 1000, transaction_type: 'expense', account: account, category: category)
        expect(transaction).to be_valid
        transaction.save
        expect(Transaction.last).to eq(transaction)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a transaction without an amount' do
        transaction.amount = nil
        expect(transaction).not_to be_valid
      end

      it 'does not create a transaction with a non-numeric amount' do
        transaction.amount = 'one hundred'
        expect(transaction).not_to be_valid
      end

      it 'does not create a transaction without a transaction_type' do
        transaction.transaction_type = nil
        expect(transaction).not_to be_valid
      end
    end
  end
end
