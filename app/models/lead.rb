class Lead < ActiveRecord::Base
  validates_uniqueness_of :email
  after_create :send_promotional_email
  
  def send_promotional_email
    class_date = self.download.class_at
    begin
      LeadMailer.promotional_email(self.email, class_date).deliver
    rescue
      self.welcome_email_sent = false
      self.save
    else
      self.welcome_email_sent = true
      self.save
    end
  end

  def download
    Download.find(self.download_id)
  end
  
end
