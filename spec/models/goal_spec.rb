require 'rails_helper'

RSpec.describe Goal, type: :model do
  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:target_amount) }
    it { should validate_numericality_of(:target_amount).is_greater_than(0) }
  end

  context "associations" do
    it { should belong_to(:user) }
  end
end
