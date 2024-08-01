# spec/helpers/application_helper_spec.rb

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "format_currency" do
    subject { helper.format_currency(amount) }
    let(:amount) {1234.56}

    it "formats the currency correctly" do
      is_expected.to eq("R$ 1.234,56")
    end

    it "uses the correct unit" do
      is_expected.to include("R$")
    end

    it "uses the correct format" do
      is_expected.to match(/R\$ \d{1,3}(\.\d{3})*,\d{2}/)
    end
  end
end
