ActiveAdmin.register Shipment do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :source, :target, :item, :status, :customer_id, :delivery_partner_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:source, :target, :item, :status, :customer_id, :delivery_partner_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :source, :target, :item, :status, :customer_id, :delivery_partner_id
  

  form do |f|
    f.inputs do
      f.input :customer
      f.input :delivery_partner
      f.input :source
      f.input :target
      f.input :item
      if f.object.persisted?
        f.input :status
      end
    end
    f.actions
  end

end
