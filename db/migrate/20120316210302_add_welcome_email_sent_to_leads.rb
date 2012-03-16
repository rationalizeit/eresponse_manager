class AddWelcomeEmailSentToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :welcome_email_sent, :boolean, :default => false
  end
end
