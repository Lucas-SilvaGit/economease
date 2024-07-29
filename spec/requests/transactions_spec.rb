require 'rails_helper'

RSpec.describe "/transactions", type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:category) { create(:category) }
  let(:valid_attributes) {
    {
      amount: 100.0,
      transaction_type: "expense",
      description: "Test Transaction",
      due_date: Time.zone.now,
      account_id: account.id,
      category_id: category.id,
      status: 'pending'
    }
  }

  let(:invalid_attributes) {
    { amount: -10.0, transaction_type: "", description: "", due_date: nil, account_id: nil, category_id: nil }
  }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Transaction.create! valid_attributes
      get transactions_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      transaction = Transaction.create! valid_attributes
      get transaction_url(transaction)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_transaction_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      transaction = Transaction.create! valid_attributes
      get edit_transaction_url(transaction)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Transaction" do
        expect {
          post transactions_url, params: { transaction: valid_attributes }
        }.to change(Transaction, :count).by(1)
      end

      it "redirects to the created transaction" do
        post transactions_url, params: { transaction: valid_attributes }
        expect(response).to redirect_to(transactions_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Transaction" do
        expect {
          post transactions_url, params: { transaction: invalid_attributes }
        }.to change(Transaction, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post transactions_url, params: { transaction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { amount: 200.0, transaction_type: "expense", description: "Updated Transaction", due_date: Time.zone.now, account_id: account.id, category_id: category.id }
      }

      it "updates the requested transaction" do
        transaction = Transaction.create! valid_attributes
        patch transaction_url(transaction), params: { transaction: new_attributes }
        transaction.reload
        expect(transaction.amount).to eq(200.0)
        expect(transaction.transaction_type).to eq("expense")
      end

      it "redirects to the transaction" do
        transaction = Transaction.create! valid_attributes
        patch transaction_url(transaction), params: { transaction: new_attributes }
        transaction.reload
        expect(response).to redirect_to(transactions_path)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested transaction" do
      transaction = Transaction.create! valid_attributes
      expect {
        delete transaction_url(transaction)
      }.to change(Transaction, :count).by(-1)
    end

    it "redirects to the transactions list" do
      transaction = Transaction.create! valid_attributes
      delete transaction_url(transaction)
      expect(response).to redirect_to(transactions_url)
    end
  end
end
