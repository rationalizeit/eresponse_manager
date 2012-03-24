class AddIndexToLeads < ActiveRecord::Migration
  def change
	add_index :leads, :download_id
  end
end
