require 'rails_helper'

RSpec.describe 'Api::V1::Items', type: :request do
  let(:user)    { create(:user) }
  let(:token)   { AuthService.generate_tokens(user)[:access_token] }
  let(:headers) { { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' } }

  describe 'GET /api/v1/items' do
    let!(:items) { create_list(:item, 3, user: user) }
    it 'returns items' do
      get '/api/v1/items', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/items' do
    let(:valid_params) { { item: { title: 'New Item', description: 'Long enough description here' } }.to_json }
    it 'creates an item' do
      post '/api/v1/items', params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
    end
    it 'returns errors for invalid params' do
      post '/api/v1/items', params: { item: { title: '' } }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/v1/items/:id' do
    let!(:item) { create(:item, user: user) }
    it 'destroys the item' do
      delete "/api/v1/items/#{item.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
