class AddCaptureDateToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :captured_on, :date
  end
end
