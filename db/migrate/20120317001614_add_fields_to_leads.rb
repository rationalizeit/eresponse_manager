class AddFieldsToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :viewed_demo, :boolean, :default => false
    add_column :leads, :viewed_demo_at, :datetime, :default => nil
  end
end
