class SendEmail < ActionMailer::Base
  
    def invalid_cc(client)
        subject       "Your Credit Card information couldn't be verfied."
        from          "ouremail"
        recipients    client.billing_email
        sent_on       Time.now
        body          :client => client
        content_type  "text/html"
    end

    def error_report(error_list)
        subject       "App Error Report"
        from          "ouremail"
        recipients    "ouremail"
        sent_on       Time.now
        body          :error_list => error_list
        content_type  "text/html"
    end

end
