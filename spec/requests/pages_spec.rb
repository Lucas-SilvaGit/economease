# spec/requests/pages_spec.rb

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  let(:user) { users(:test) }

  describe 'GET /' do
    context 'when signed in' do
      before do
        sign_in user
        get root_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when signed out' do
      before do
        get root_path
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
