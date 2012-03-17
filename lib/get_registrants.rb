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
    download = Download.last
    format = "%m/%d/%Y %H:%M:%S"
    last_downloaded_registrant = Lead.where('viewed_demo = true').max_by{|l| l.viewed_demo_at}
    array_of_hashes.select{|hash| DateTime.strptime(hash['Timestamp'], format) > last_downloaded_registrant.viewed_demo_at}.each do |hash|
      download.leads.create(:email => hash['Email'])
      lead = Lead.find_by_email(hash['Email'])
      lead.first_name = hash['Full Name'].split(' ').first
      lead.last_name = hash['Full Name'].split(' ').last
      lead.phone_number = hash['Phone Number'].gsub(/[^0-9]/, '') 
      lead.viewed_demo = true
      puts hash['Timestamp']
      lead.viewed_demo_at = DateTime.strptime(hash['Timestamp'], format)
      lead.save
    end
    File.delete(file_name)
    
  end




end
