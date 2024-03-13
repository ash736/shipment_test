class DeliveryPartner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :shipments
  validates :name, presence: true

  scope :available, -> { 
    where(active_for_delivery: true)
  }

  def self.least_shipments_with_pending_or_shipped
    available.min_by do |partner|
      partner.shipments.where(status: ["pending", "shipped"]).count
    end
  end


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email"]
  end

end
