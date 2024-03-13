require 'rails_helper'

RSpec.describe "Shipments", type: :request do
  context 'when logged in as a customer' do
    let(:customer) { create(:customer) }
    let!(:pending_shipments) { create_list(:shipment, 3, status: :pending, customer: customer) }
    let!(:shipped_shipments) { create_list(:shipment, 2, status: :shipped, customer: customer) }
    let!(:cancelled_shipments) { create_list(:shipment, 1, status: :cancelled, customer: customer) }
    let!(:delivered_shipments) { create_list(:shipment, 1, status: :delivered, customer: customer) }

    before do
      sign_in customer
    end

    it 'returns a successful response' do
      get shipments_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new shipment template' do
      get new_shipment_path
      expect(response).to have_http_status(:success)
    end

    it 'create a new shipment' do
      post shipments_path, params: { shipment: { source: 'source', target: 'target', item: 'item'} }
      expect(response).to have_http_status(302)
    end

    it 'cancel a shipment' do
      shipment = pending_shipments.first
      put update_status_shipment_path(shipment, format: :turbo_stream), params: { status: 'cancelled' }
      expect(response).to have_http_status(200)
      expect(shipment.reload.status).to eq('cancelled')
    end

    it 'pending a shipment' do
      shipment = cancelled_shipments.first
      put update_status_shipment_path(shipment, format: :turbo_stream), params: { status: 'pending' }
      expect(response).to have_http_status(200)
      expect(shipment.reload.status).to eq('pending')
    end
  end
end
