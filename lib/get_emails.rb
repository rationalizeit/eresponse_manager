class GetEmails
  include GCal4Ruby
  @last_downloaded_mail ||= 0
  def self.perform
    mail = Gmail.connect(GMAIL_USERNAME, GMAIL_PWD)
    last_uid ||= 0
    todays_mail = []
    if Download.last
      last_uid = Download.last.last_uid 
      todays_mail = mail.label('test').emails(:after => Download.last.created_at)
      todays_mail = todays_mail.select {|d| d.uid > Download.last.last_uid} unless todays_mail.blank? 
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
   todays_registrants = GetRegistrants.perform
   #dont send the sample mail if nothing happened
   resend_failed_emails 
   unless todays_mail.empty? && todays_registrants.empty?
    create_event
    send_summary_mail(Download.last.id) 
   end
   mail.logout
  end

  def self.send_summary_mail(download_id)
    SummaryEmail.summary_email(download_id).deliver
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

  def self.create_event
    begin
    service = Service.new
    service.authenticate(GMAIL_USERNAME, GMAIL_PWD)
    cal = service.calendars.first
    download_time = Download.last.created_at
    # Schedule for tomorrow if its already past 6 PM
    meeting_date = download_time.hour >=18? Date.tomorrow : Date.today
    event_options = {:title => 'Call Training Leads', 
                     :calendar => cal,
                     :start_time => Time.parse("#{meeting_date} at 6 pm"),
                     :end_time => Time.parse("#{meeting_date} at 6.30 pm"),
                     :where => 'Your Phone',
    }
    event = Event.new(service,event_options)
    event.save
    rescue nil
    end
  end

end
