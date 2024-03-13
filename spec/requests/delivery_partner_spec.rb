require 'rails_helper'

RSpec.describe "DeliveryPartners", type: :request do
  context 'when logged in as a delivery partner' do
    let(:delivery_partner) { create(:delivery_partner) }
    let!(:pending_shipments) { create_list(:shipment, 3, status: :pending, delivery_partner: delivery_partner) }
    let!(:shipped_shipments) { create_list(:shipment, 2, status: :shipped, delivery_partner: delivery_partner) }
    let!(:cancelled_shipments) { create_list(:shipment, 1, status: :cancelled, delivery_partner: delivery_partner) }
    let!(:delivered_shipments) { create_list(:shipment, 1, status: :delivered, delivery_partner: delivery_partner) }

    before do
      sign_in delivery_partner
    end

    it 'returns a successful response' do
      get shipments_path
      expect(response).to have_http_status(:success)
    end

    it 'shipped a shipment' do
      shipment = pending_shipments.first
      put update_status_shipment_path(shipment, format: :turbo_stream), params: { status: 'shipped' }
      expect(response).to have_http_status(200)
      expect(shipment.reload.status).to eq('shipped')
    end

    it 'delivered a shipment' do
      shipment = shipped_shipments.first
      put update_status_shipment_path(shipment, format: :turbo_stream), params: { status: 'delivered' }
      expect(response).to have_http_status(200)
      expect(shipment.reload.status).to eq('delivered')
    end

    it 'inactive' do
      put delivery_partner_update_availability_path(format: :turbo_stream), params: { available: false }
      expect(response).to have_http_status(200)
      expect(delivery_partner.reload.active_for_delivery).to eq(false)
    end

    it 'active' do
      delivery_partner.update(active_for_delivery: false)
      put delivery_partner_update_availability_path(format: :turbo_stream), params: { available: true }
      expect(response).to have_http_status(200)
      expect(delivery_partner.reload.active_for_delivery).to eq(true)
    end

  end
end
