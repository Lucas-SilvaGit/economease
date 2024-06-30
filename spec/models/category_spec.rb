require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { build(:category) }

  describe 'validations' do
    it 'validates presence of name' do
      category.name = nil
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")

      category.name = 'Electronics'
      category.valid?
      expect(category.errors[:name]).to be_empty
    end
  end

  describe 'creating a category' do
    context 'with valid parameters' do
      it 'creates a new category successfully' do
        category.name = 'Electronics'
        expect(category).to be_valid
        category.save
        expect(Category.last).to eq(category)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a category without a name' do
        category.name = nil
        expect(category).not_to be_valid
      end
    end
  end
end
