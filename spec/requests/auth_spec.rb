require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'POST /api/v1/auth/register' do
    let(:params) { { user: { name: 'Test', email: 'test@example.com', password: 'Password1!', password_confirmation: 'Password1!' } }.to_json }
    it 'registers a user' do
      post '/api/v1/auth/register', params: params, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('access_token')
    end
  end

  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'login@example.com', password: 'Password1!') }
    it 'logs in successfully' do
      post '/api/v1/auth/login', params: { email: 'login@example.com', password: 'Password1!' }.to_json, headers: headers
      expect(response).to have_http_status(:ok)
    end
    it 'rejects invalid credentials' do
      post '/api/v1/auth/login', params: { email: 'login@example.com', password: 'wrong' }.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
