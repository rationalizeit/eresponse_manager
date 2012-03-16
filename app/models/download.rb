class Download < ActiveRecord::Base
  has_many :leads

  def self.perform
    mail = Gmail.connect(GMAIL_USERNAME, GMAIL_PWD)
    todays_mail = mail.label('test').emails.select {|email| email.uid > self.max_by(:created_at).created_at}
    unless todays_mail.empty?
      todays_mail.each do |email|
        address = email.message.from.first_to_s unless email.message.from.blank? || email.message.from.first.index('sulekha')
        self.leads.create(:email => address)
      end
    end
    send_sample_emails
  end
  def self.send_sample_mail
    #LeadMailer.promotional_email('faraaz@rationalizeit.us').deliver
  end
end
