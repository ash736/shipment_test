class ShipmentsController < ApplicationController
  before_action :authenticate_user, only: [:index, :update_status]
  before_action :authenticate_customer!, only: [:new, :create]

  def index
    if current_customer
      @shipments = current_customer.shipments.includes(:delivery_partner)
      render 'shared/customers/shipment_index'
    elsif current_delivery_partner
      @delivery_partner = current_delivery_partner
      @shipments = current_delivery_partner.shipments.includes(:customer)
      render 'shared/delivery_partners/shipment_index'
    end
  end

  def new
    @shipment = Shipment.new
  end

  def create
    chosen_partner = DeliveryPartner.least_shipments_with_pending_or_shipped

    @shipment = current_customer.shipments.build(shipment_params)
    @shipment.delivery_partner = chosen_partner if chosen_partner.present?
    if @shipment.save
      redirect_to shipments_path, notice: "Shipment created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_status
    @shipment = Shipment.find(params[:id])
    @shipment.update(status: params[:status])
    redirect_to shipments_path, notice: "Shipment status updated successfully"
  end

  private

  def shipment_params
    params.require(:shipment).permit(:source, :target, :item)
  end

  def authenticate_user
    unless (customer_signed_in? || delivery_partner_signed_in?)
      redirect_to new_customer_session_path
    end
  end
end
  