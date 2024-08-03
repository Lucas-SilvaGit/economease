require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  before(:each) do
    User.delete_all
  end

  describe 'validations' do
    it 'validates presence of email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("não pode ficar em branco")

      user.email = Faker::Internet.unique.email
      user.valid?
      expect(user.errors[:email]).to be_empty
    end

    it 'validates uniqueness of email' do
      existing_user = create(:user)
      user.email = existing_user.email
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('já está em uso')

      user.email = Faker::Internet.unique.email
      user.valid?
      expect(user.errors[:email]).to be_empty
    end

    it 'validates presence of password' do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("não pode ficar em branco")

      user.password = 'securepassword'
      user.valid?
      expect(user.errors[:password]).to be_empty
    end

    it 'validates length of password' do
      user.password = 'short'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('é muito curto (mínimo: 6 caracteres)')

      user.password = 'adequatelylongpassword'
      user.valid?
      expect(user.errors[:password]).to be_empty
    end
  end

  describe 'associations' do
    it 'has many accounts' do
      expect(user).to respond_to(:accounts)
    end
  end

  describe 'creating a user' do
    context 'with valid parameters' do
      it 'creates a new user successfully' do
        expect(user).to be_valid
        user.save
        expect(User.last).to eq(user)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user without an email' do
        user.email = nil
        expect(user).not_to be_valid
      end

      it 'does not create a user with a duplicate email' do
        create(:user, email: Faker::Internet.unique.email)
        user.email = User.last.email
        expect(user).not_to be_valid
      end

      it 'does not create a user without a password' do
        user.password = nil
        expect(user).not_to be_valid
      end

      it 'does not create a user with a short password' do
        user.password = 'short'
        expect(user).not_to be_valid
      end
    end
  end
end
