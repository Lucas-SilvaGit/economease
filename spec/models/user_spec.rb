require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  before(:each) do
    User.delete_all
  end

  context "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  context "associations" do
    it { should have_many(:accounts).dependent(:destroy) }
    it { should have_many(:goals).dependent(:destroy) }
  end
end
