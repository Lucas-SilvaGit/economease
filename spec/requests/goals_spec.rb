require 'rails_helper'

RSpec.describe "/goals", type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) {
    {
      name: "New Goal",
      target_amount: 1000.0,
      current_amount: 0.0,
      target_date: "2023-12-31",
      saved_value: 0.0,
      user_id: user.id
    }
  }

  let(:invalid_attributes) {
    {
      name: "",
      target_amount: nil,
      current_amount: nil,
      target_date: nil,
      saved_value: nil,
      user_id: nil
    }
  }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Goal.create! valid_attributes
      get goals_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      goal = Goal.create! valid_attributes
      get goal_url(goal)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_goal_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      goal = Goal.create! valid_attributes
      get edit_goal_url(goal)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Goal" do
        expect {
          post goals_url, params: { goal: valid_attributes }
        }.to change(Goal, :count).by(1)
      end

      it "redirects to the created goal" do
        post goals_url, params: { goal: valid_attributes }
        expect(response).to redirect_to(goals_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Goal" do
        expect {
          post goals_url, params: { goal: invalid_attributes }
        }.to change(Goal, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post goals_url, params: { goal: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          name: "Updated Goal",
          target_amount: 2000.0,
          current_amount: 100.0,
          target_date: "2024-01-01",
          saved_value: 100.0
        }
      }

      it "updates the requested goal" do
        goal = Goal.create! valid_attributes
        patch goal_url(goal), params: { goal: new_attributes }
        goal.reload
        expect(goal.name).to eq("Updated Goal")
        expect(goal.target_amount).to eq(2000.0)
        expect(goal.current_amount).to eq(100.0)
        expect(goal.target_date.strftime('%Y-%m-%d')).to eq("2024-01-01")
        expect(goal.saved_value).to eq(100.0)
      end

      it "redirects to the goal" do
        goal = Goal.create! valid_attributes
        patch goal_url(goal), params: { goal: new_attributes }
        goal.reload
        expect(response).to redirect_to(goals_path)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        goal = Goal.create! valid_attributes
        patch goal_url(goal), params: { goal: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested goal" do
      goal = Goal.create! valid_attributes
      expect {
        delete goal_url(goal)
      }.to change(Goal, :count).by(-1)
    end

    it "redirects to the goals list" do
      goal = Goal.create! valid_attributes
      delete goal_url(goal)
      expect(response).to redirect_to(goals_url)
    end
  end
end
