class LeadMailer < ActionMailer::Base
  default :from => "faraaz@rationalizeit.us",
            :to => "faraaz@rationalizeit.us"

  def promotional_email(leads=[])
    @users = leads.map(&:email) unless leads.empty?
    date = 10.days.since
    new_date = (date + (8-date.wday).days)
    @date = new_date.strftime('%A, %B %d %G')
    options = {}
    options[:subject] = "BA Training from Rationalize IT, LLC, New Batch on #{new_date.strftime('%m/%d/%Y')}"
    options[:bcc] = @users unless leads.empty?
       # attachments.inline['background-1.jpg'] = File.read('/assets/background-1.jpg')
       #            attachments.inline['background.jpg'] = File.read('/assets/background.jpg')
       #            attachments.inline['button.jpg'] = File.read('/assets/button.jpg')
       #            attachments.inline['content-bg.jpg'] = File.read('/assets/content-bg.jpg')
       #            attachments.inline['top.jpg'] = File.read('/assets/top.jpg')  
        mail(options)
  end
end
