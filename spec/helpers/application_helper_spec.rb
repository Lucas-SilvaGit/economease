# spec/helpers/application_helper_spec.rb
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#format_currency' do
    it 'formats the currency correctly' do
      amount = 1234.56
      formatted_amount = helper.format_currency(amount)
      expect(formatted_amount).to eq('R$ 1.234,56')
    end

    it 'uses the correct unit' do
      amount = 1234.56
      formatted_amount = helper.format_currency(amount)
      expect(formatted_amount).to include('R$')
    end

    it 'uses the correct format' do
      amount = 1234.56
      formatted_amount = helper.format_currency(amount)
      expect(formatted_amount).to match(/R\$ \d{1,3}(\.\d{3})*,\d{2}/)
    end
  end
end
