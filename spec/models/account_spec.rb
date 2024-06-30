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

    it 'validates presence of balance' do
      account.balance = nil
      expect(account).not_to be_valid
      expect(account.errors[:balance]).to include("can't be blank")

      account.balance = 1000
      account.valid?
      expect(account.errors[:balance]).to be_empty
    end

    it 'validates numericality of balance greater than 0' do
      account.balance = -100
      expect(account).not_to be_valid
      expect(account.errors[:balance]).to include("must be greater than 0")

      account.balance = 1000
      account.valid?
      expect(account.errors[:balance]).to be_empty
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

      it 'does not create an account without a balance' do
        account.balance = nil
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
end
