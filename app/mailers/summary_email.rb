class SummaryEmail < ActionMailer::Base
  default from: "faraaz@rationalizeit.us",
            to: "faraaz@rationalizeit.us",
       subject: "Your leads summary for #{Date.today}"

  def summary_email(download_id)
    download = Download.find(download_id)
    @leads_count = download.leads.where('viewed_demo = false').count
    @registrants_count = download.leads.where('viewed_demo = true').count
    mail
    
  end
end
