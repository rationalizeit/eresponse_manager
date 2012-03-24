class AddIndexToLeadsCapturedOn < ActiveRecord::Migration
  def change
	add_index :leads, :captured_on
  end
end
