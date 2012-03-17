class GetEmails
  @last_downloaded_mail ||= 0
  def self.perform
    mail = Gmail.connect(GMAIL_USERNAME, GMAIL_PWD)
    last_uid ||= 0
    todays_mail = []
    if Download.last
      last_uid = Download.last.last_uid 
      todays_mail = mail.label('test').emails(:after => Download.last.created_at).select {|d| d.uid > Download.last.uid}
    else 
      todays_mail = mail.label('test').emails
    end
    date = 10.days.since
    date = (date + (8-date.wday).days)
    unless todays_mail.empty?
      uid = todays_mail.max_by(&:uid).uid
      Download.create(:last_uid => uid, :class_at => date)
      todays_mail.each do |email|
        address =  email.message.from.first.to_s unless email.message.from.blank? || email.message.from.first.index('sulekha')
        Download.last.leads.create(:email => address) if address
      end
    end
   GetRegistrants.perform
   send_sample_mail 
   resend_failed_emails 
   mail.logout
  end

  def self.send_sample_mail
    LeadMailer.promotional_email('faraaz@rationalizeit.us', Download.last.class_at).deliver
    end
 
  def self.resend_failed_emails
    failed_emails = Lead.where('welcome_email_sent = false')
    unless failed_emails.empty?
      failed_emails.each do |lead|
        begin
          LeadMailer.promotional_email(lead.email, lead.download.class_at).deliver
        rescue nil
        else
          lead.welcome_email_sent = true
          lead.save
        end
      end
    end
  end

end
