

class LeadMailer < ActionMailer::Base
  default :from => "faraaz@rationalizeit.us"

  def promotional_email(email, batch_date)
    @date = batch_date.strftime('%A, %B %d %G')
    #check if we know the first name, if not then
    #Try to guess the name of the user from the email
    @name = Lead.find_by_email(email).try(:first_name).try(:titleize) || email.gsub(/[^A-Za-z]/, '@').split('@').first.titleize
    options = {}
    options[:to] = email.to_s
    options[:from_alias] = "Rationalize IT, LLC"
    options[:subject] = "BA Training from Rationalize IT, LLC, New Batch on #{batch_date.strftime('%m/%d/%Y')}"
    puts options
    mail(options)
  end
end

