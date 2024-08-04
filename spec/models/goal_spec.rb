require 'rails_helper'

RSpec.describe Goal, type: :model do
  context "validations" do
    let(:user) { create(:user) }
    let(:goal) { build(:goal, user: user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:target_amount) }

    it "validates numericality of target_amount" do
      goal.name = "Valid Goal"
      goal.target_amount = -1

      expect(goal).not_to be_valid
      expect(goal.errors[:target_amount]).to include("deve ser maior que 0")
    end
  end

  context "associations" do
    it { should belong_to(:user) }
  end
end
