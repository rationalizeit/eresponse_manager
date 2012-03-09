class GetEmails
  def self.perform
    mail = Gmail.connect(GMAIL_USERNAME, GMAIL_PWD)
    midnight_the_previous_day = (Date.today-5).to_time
    todays_mail = mail.label('test').emails(:after => midnight_the_previous_day)
    unless todays_mail.empty?
      todays_mail.each do |email|
        address =  email.message.from.first.to_s unless email.message.from.blank? || email.message.from.first.index('sulekha')
        Lead.create(:email => address) 
      end
    end
    send_promotional_email
  end
  
  def self.send_promotional_email
    LeadMailer.promotional_email.deliver
  end
end
