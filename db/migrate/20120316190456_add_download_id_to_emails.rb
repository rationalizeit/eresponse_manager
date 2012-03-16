class AddDownloadIdToEmails< ActiveRecord::Migration
  def change
    add_column :leads, :download_id, :integer, :default => 0
  end
end
