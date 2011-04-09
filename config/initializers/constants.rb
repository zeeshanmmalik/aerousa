require 'openssl'
ENVIRONMENT = "DEVELOPMENT" #either DEVELOPMENT or PRODUCTION


SEND_EMAIL = false #if app should send email to customer if CC payment failed
SKU_PREFIX = 'ARO-' #prefix to add to SKU for webgistix orders
WEBGISTIX_TRACKING_HEADER = "/XML/GetTracking.asp"  
WEBGISTIX_LOGIN_INFO = "<Password>hKd6nyPY359x</Password>" + 
                       "<CustomerID>464</CustomerID>"

PUBLIC_KEY_FILE = Rails.root.join('db','public.pem')
PRIVATE_KEY_FILE = Rails.root.join('db', 'private.pem')
PASSKEY = '7vz5pq23jksd74jglx9psu1dfn'

PUBLIC_KEY = OpenSSL::PKey::RSA.new(File.read(PUBLIC_KEY_FILE))
PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY_FILE),PASSKEY)

if ENVIRONMENT.eql?("DEVELOPMENT")
  # credit card processing info
   CC_URL = "https://demo.myvirtualmerchant.com"
   CC_TARGET_HEADER = "/VirtualMerchantDemo/process.do?"
   CC_LOGIN = "ssl_merchant_id=000092&" +
      "ssl_user_id=webpage&" +
      "ssl_pin=5QWRHN&" +
      "ssl_transaction_type=ccsale&" 
   #TODO try HTTPS...
   WEBGISTIX_URL = "http://www.webgistix.com"
   WEBGISTIX_HEADER = "/XML/CreateOrderTest.asp"

else
  # credit card processing info

  # PRODUCTION credentials removed. TODO: move all configuration to a config file /config/application.yml, not tracked in svn/git, and create a file /config/application.yml.example tracked in source-control
end



