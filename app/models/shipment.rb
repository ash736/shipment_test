class Shipment < ApplicationRecord
  belongs_to :customer
  belongs_to :delivery_partner, optional: true

  validates :source, :target, :item, presence: true

  validates :status, presence: true, on: :update

  enum status: [:pending, :shipped, :delivered, :cancelled]

  before_create :set_default_status

  def set_default_status
    self.status = :pending
  end

  validate :not_cancelled_after_shipped_or_delivered, if: :status_changed?

  private

  def not_cancelled_after_shipped_or_delivered
    if ((status == "cancelled") || (status == "pending")) && (shipped? || delivered?)
      errors.add(:status, "can't be cancelled after shipment is shipped or delivered")

    elsif (status == "shipped") && (delivered?)
      errors.add(:status, "can't be shipped after shipment is delivered")

    elsif cancelled?
      errors.add(:status, "can't be shipped after shipment is cancelled")
    end
  end
end
