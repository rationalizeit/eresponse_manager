require 'google_spreadsheet'
require 'csv'

class GetRegistrants

  def self.perform
    session = GoogleSpreadsheet.login(P_USERNAME, P_PWD)
    spreadsheet = session.spreadsheet_by_key(REGISTER_KEY)
    file_name = 'public/registrant_list.csv'
    file = spreadsheet.export_as_file(file_name, format = 'csv')
    csv_data = CSV.read file_name
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
    date = 10.days.since
    date = (date + (8-date.wday).days)
    download = Download.last.class_at == date ? Download.last : Download.create(:class_at => date)
    format = "%m/%d/%Y %H:%M:%S"
    last_downloaded_registrant = Lead.where('viewed_demo = true').max_by{|l| l.viewed_demo_at}
    todays_registrants = last_downloaded_registrant ? (array_of_hashes.select{|hash| DateTime.strptime(hash['Timestamp'], format) > last_downloaded_registrant.viewed_demo_at}) : array_of_hashes
    todays_registrants.each do |hash|
      email = hash['Email'].to_s.downcase
      options = {
      :email => email, 
      :captured_on => DateTime.strptime(hash['Timestamp'], format), 
      :first_name => hash['Full Name'].split(' ').first, 
      :last_name => hash['Full Name'].split(' ').last, 
      :phone_number => hash['Phone Number'].gsub(/[^0-9]/, ''), 
      :viewed_demo => true,
      :viewed_demo_at => DateTime.strptime(hash['Timestamp'], format),
      :download_id => download.id
    }
    Lead.find_by_email(email) ? true : Lead.create(options)    
    end
    File.delete(file_name)
    todays_registrants
    
  end




end
