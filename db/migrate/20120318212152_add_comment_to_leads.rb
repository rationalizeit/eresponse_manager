class AddCommentToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :comment, :text
  end
end
