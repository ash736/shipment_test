class DeliveryPartnerController < ApplicationController
  before_action :authenticate_delivery_partner!

  def update_avilability
    @delivery_partner = current_delivery_partner
    @delivery_partner.update(active_for_delivery: params[:available])
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace('delivery_partner_status', partial: "shared/delivery_partners/status_button")
      }
    end
  end
end
