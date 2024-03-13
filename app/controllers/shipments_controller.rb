class ShipmentsController < ApplicationController
  before_action :authenticate_user, only: [:index, :update_status]
  before_action :authenticate_customer!, only: [:new, :create]

  def index
    if current_customer
      @non_deliver_shipments = current_customer.shipments.includes(:delivery_partner).not_delivered
      @deliver_shipments = current_customer.shipments.includes(:delivery_partner).delivered
      render 'shared/customers/shipment_index'
    elsif current_delivery_partner
      @delivery_partner = current_delivery_partner
      @non_deliver_shipments = current_delivery_partner.shipments.includes(:customer).not_delivered.not_cancelled
      @deliver_shipments = current_delivery_partner.shipments.includes(:customer).delivered.not_cancelled
      render 'shared/delivery_partners/shipment_index'
    end
  end

  def new
    @shipment = Shipment.new
  end

  def create
    @shipment = current_customer.shipments.build(shipment_params)
    if @shipment.save
      redirect_to shipments_path, notice: "Shipment created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_status
    @shipment = Shipment.find(params[:id])
    template = current_customer ? 'shared/customers/status_form' : 'shared/delivery_partners/status_form'
    respond_to do |format|
      if @shipment.update(status: params[:status])
        format.turbo_stream { render turbo_stream: turbo_stream.replace("status_form_#{@shipment.id}", partial: template, locals: { shipment: @shipment }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("status_form_#{@shipment.id}", partial: template, locals: { shipment: @shipment.reload }) }
      end
    end
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
  