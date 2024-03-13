class Shipment < ApplicationRecord
  belongs_to :customer
  belongs_to :delivery_partner, optional: true

  validates :source, :target, :item, presence: true

  validates :status, presence: true, on: :update

  enum status: [:pending, :shipped, :delivered, :cancelled]

  before_create :set_default_status_and_partner

  def set_default_status_and_partner
    self.status = :pending
    self.delivery_partner = DeliveryPartner.least_shipments_with_pending_or_shipped
  end

  validate :not_cancelled_after_shipped_or_delivered, if: :status_changed?

  private

  def not_cancelled_after_shipped_or_delivered
    if ((status == "cancelled") || (status == "pending")) && (status_was == 'shipped' || status_was == 'delivered')
      errors.add(:status, "can't be cancelled after shipment is shipped or delivered")
    elsif (status == "shipped") && (status_was == 'delivered')
      errors.add(:status, "can't be shipped after shipment is delivered")
    elsif status_was == 'cancelled' && (status == 'shipped' || status == 'delivered')
      errors.add(:status, "can't be shipped after shipment is cancelled")
    end
  end


  def self.ransackable_associations(auth_object = nil)
    ["customer", "delivery_partner"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["customer_id", "delivery_partner_id", "item", "source", "status", "target"]
  end
end
