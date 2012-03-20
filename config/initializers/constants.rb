
if Rails.env == 'production'
  GMAIL_USERNAME = ENV['GMAIL_USERNAME']
  GMAIL_PWD = ENV['GMAIL_PWD']
  P_USERNAME = ENV['P_USERNAME']
  P_PWD = ENV['P_PWD']
  REGISTER_KEY = ENV['REGISTER_KEY']
  P_GVOICE_RNR = ENV['P_GVOICE_RNR']
  T_GVOICE_RNR = ENV['T_GVOICE_RNR']
  T_USERNAME = ENV['T_USERNAME']
  T_PWD = ENV['T_PWD']
else 
  GMAIL_USERNAME = 'faraaz@rationalizeit.us'
  GMAIL_PWD = 'India2011!'
  P_USERNAME = 'faraaz.com@gmail.com'
  P_PWD = 'India2011!'
  REGISTER_KEY = '0AsC-ApYG8xl1dDVTS0o4U0ZqOEpaRWdyNjY0WTdMVEE'
  P_GVOICE_RNR = 'NIiwANxk6TX3dP+kh2oPLEh9hTo='
  T_GVOICE_RNR = 'fI5yW3B2WPAlg8uM+8Ei0g3qkd4='
  T_USERNAME = 'training@rationalizeit.us'
  T_PWD = 'iffath123'
end



