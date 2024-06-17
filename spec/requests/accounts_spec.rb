require 'rails_helper'

RSpec.describe "/accounts", type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) {
    { name: "Test Account", balance: 100.0, user_id: user.id }
  }

  let(:invalid_attributes) {
    { name: "", balance: -10.0, user_id: nil }
  }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Account.create! valid_attributes
      get accounts_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      account = Account.create! valid_attributes
      get account_url(account)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_account_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      account = Account.create! valid_attributes
      get edit_account_url(account)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Account" do
        expect {
          post accounts_url, params: { account: valid_attributes }
        }.to change(Account, :count).by(1)
      end

      it "redirects to the created account" do
        post accounts_url, params: { account: valid_attributes }
        expect(response).to redirect_to(accounts_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Account" do
        expect {
          post accounts_url, params: { account: invalid_attributes }
        }.to change(Account, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post accounts_url, params: { account: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "Updated Account", balance: 200.0 }
      }

      it "updates the requested account" do
        account = Account.create! valid_attributes
        patch account_url(account), params: { account: new_attributes }
        account.reload
        expect(account.name).to eq("Updated Account")
        expect(account.balance).to eq(200.0)
      end

      it "redirects to the account" do
        account = Account.create! valid_attributes
        patch account_url(account), params: { account: new_attributes }
        account.reload
        expect(response).to redirect_to(accounts_path)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        account = Account.create! valid_attributes
        patch account_url(account), params: { account: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested account" do
      account = Account.create! valid_attributes
      expect {
        delete account_url(account)
      }.to change(Account, :count).by(-1)
    end

    it "redirects to the accounts list" do
      account = Account.create! valid_attributes
      delete account_url(account)
      expect(response).to redirect_to(accounts_url)
    end
  end
end
