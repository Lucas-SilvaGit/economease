require 'rails_helper'

RSpec.describe Goal, type: :model do
  let(:user) { create(:user) }
  let(:goal) { create(:goal, user: user) }

  describe 'validations' do
    it 'validates presence of name' do
      goal.name = nil
      expect(goal).not_to be_valid
      expect(goal.errors[:name]).to include("can't be blank")

      goal.name = 'Vacation'
      goal.valid?
      expect(goal.errors[:name]).to be_empty
    end

    it 'validates presence of target_amount' do
      goal.target_amount = nil
      expect(goal).not_to be_valid
      expect(goal.errors[:target_amount]).to include("can't be blank")

      goal.target_amount = 5000
      goal.valid?
      expect(goal.errors[:target_amount]).to be_empty
    end

    it 'validates numericality of target_amount greater than 0' do
      goal.target_amount = -100
      expect(goal).not_to be_valid
      expect(goal.errors[:target_amount]).to include("must be greater than 0")

      goal.target_amount = 5000
      goal.valid?
      expect(goal.errors[:target_amount]).to be_empty
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(goal.user).to eq(user)
    end
  end

  describe 'creating a goal' do
    context 'with valid parameters' do
      it 'creates a new goal successfully' do
        goal = build(:goal, name: 'Vacation', target_amount: 5000, user: user)
        expect(goal).to be_valid
        goal.save
        expect(Goal.last).to eq(goal)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a goal without a name' do
        goal.name = nil
        expect(goal).not_to be_valid
      end

      it 'does not create a goal without a target_amount' do
        goal.target_amount = nil
        expect(goal).not_to be_valid
      end

      it 'does not create a goal with a negative target_amount' do
        goal.target_amount = -100
        expect(goal).not_to be_valid
      end

      it 'does not create a goal with a non-numeric target_amount' do
        goal.target_amount = 'five thousand'
        expect(goal).not_to be_valid
      end
    end
  end
end
