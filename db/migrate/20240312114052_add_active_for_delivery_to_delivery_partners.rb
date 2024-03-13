class AddActiveForDeliveryToDeliveryPartners < ActiveRecord::Migration[7.1]
  def change
    add_column :delivery_partners, :active_for_delivery, :boolean, default: false
  end
end
