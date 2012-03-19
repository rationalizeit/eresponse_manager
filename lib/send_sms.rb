require 'net/http'
require 'net/https'
require 'uri'


class SendSMS
  def self.deliver(lead=nil, number=nil, message)
    number = number || lead.phone_number
    if number.to_s.size == 10 && !message.empty?
      begin
        login_response = ''
        url = URI.parse('https://www.google.com/accounts/ClientLogin')
        login_req = Net::HTTP::Post.new(url.path)
        login_req.form_data = {'accountType' => 'GOOGLE', 'Email' => T_USERNAME, 'Passwd' => T_PWD, 'service' => 'grandcentral', 'source' => 'Rationalize IT BA Training'}
        login_con = Net::HTTP.new(url.host, url.port)
        login_con.use_ssl = true
        login_con.start {|http| login_response = http.request(login_req)}

        url = URI.parse('https://www.google.com/voice/sms/send/')
        req = Net::HTTP::Post.new(url.path, { 'Content-type' => 'application/x-www-form-urlencoded', 'Authorization' => 'GoogleLogin auth='+login_response.body.match("Auth\=(.*)")[0].gsub("Auth=", "") })
        # We're sending the auth token back to google
        req.form_data = {'id' => '', 'phoneNumber' => number, 'text' => message, '_rnr_se' => T_GVOICE_RNR}
        con = Net::HTTP.new(url.host, url.port)
        con.use_ssl = true
        con.start {|http| response = http.request(req)}
      rescue nil
      else 'Message sent!'
      end
    end
  end
end
