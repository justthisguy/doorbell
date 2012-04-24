class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  
    def sms

      Rails.logger.debug("******************** these be the params #{params} ")

      body = params[:Body].split
      phone = params[:From]
      
      Rails.logger.debug("******************** these is the body #{body} ")
      
      

      case body[0]
        when "add"
          doorman = Doorman.new
          doorman.phone = phone
          doorman.save

          Rails.logger.debug('new doorman ' + doorman.to_s)
          render :text => '<Response><Sms>add</Sms></Response>', :content_type => "text/xml"

        when "remove" 
          doorman = Doorman.find_by_phone(phone)

          if doorman.destroy 
            render :text => '<Response><Sms>You have been removed. SURF thanks you for your help.</Sms></Response>', :content_type => "text/xml"
          end

        when "door"
          account_sid = 'ACbbefae45e9c349aa931498bd315c85e1'
          auth_token = '748a6fa66c8d70882fdbb9424b5c0944'
          @client = Twilio::REST::Client.new account_sid, auth_token

          Doorman.all.each do |d|

            Rails.logger.debug("doorman message to #{d.phone} from #{phone}")

            @client.account.sms.messages.create(
              :from => '4155992671',
              :to => d.phone,
              :body => phone + ' is at the door'
              )
          end

          render :text => '<Response><Sms>Give us a minute please. Help is on the way.</Sms></Response>', :content_type => "text/xml"
 
 
        when "event" 
          
          Rails.logger.debug('************************** calling event SMS ' + body.to_s)
          
          message = Event.sms(params, body)
          return render :text => "<Response><Sms>#{message}</Sms></Response>", :content_type => "text/xml"


        else
          render :text => "<Response><Sms>SAY WHAT?  Send 'door' to get in/Sms></Response>", :content_type => 'text/xml'
      end
    end
  
end
