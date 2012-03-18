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
        address =  email.message.from.first.to_s.downcase unless email.message.from.blank? || email.message.from.first.index('sulekha')
        #decode email
        decoded_mail = email.message.decode_body
        #require 'ruby-debug'; debugger if address == 'sadf@sv.com'
        # parse decoded mail to get Phone Number if available
        phone = decoded_mail.gsub(/.*?(?=Phone)/im, "")[0,24] || ''
        phone.gsub!(/[^0-9]/,'')
        #Verify if Phone Number was correctly retrieved
        phone_number = phone.to_i unless phone.blank? || phone.size != 10
        # parse decoded mail to get Name if available
        name_string = decoded_mail.gsub(/.*?(?=Contact Details of)/im, "")
        unless name_string.blank?
         name_index = name_string.index('<br>')
         name = name_string[0,name_index][21,name_index]
        end
        #require 'ruby-debug'; debugger if address == 'ramramyaus@yahoo.com'
        if decoded_mail.index('Message')
         comment_index = decoded_mail.gsub(/.*?(?=Message)/im,'').index('</td>')
         comment = decoded_mail.gsub(/.*?(?=Message)/im,'')[11,comment_index-11].gsub(/[^A-Za-z ,.:!]/,'').gsub(/[\s]+/, ' ')
        end
        options = {}
        options[:email]= address if address
        options[:phone_number] = phone_number if phone_number
        options[:first_name] = name if name
        options[:captured_on]= email.envelope.date
        options[:comment] = comment unless comment.blank?
        Download.last.leads.create(options) if options[:email] 
      end
    end
   todays_registrants = GetRegistrants.perform
   #dont send the sample mail if nothing happened
   #resend_failed_emails 
   unless todays_mail.empty? && todays_registrants.empty?
    create_event
    #send_summary_mail(Download.last.id) 
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
