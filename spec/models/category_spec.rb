require 'rails_helper'

RSpec.describe Category, type: :model do
  context "validations" do
    let(:category) { build(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).with_message("já está em uso") }
  end

  context "associations" do
    it { should have_many(:transactions).dependent(:destroy) }
  end
end
