class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :twilio_init

  ###
  # SEE BELOW FOR A FULL PARAMS SET
  ###


  ## TODO: decide on data model
  ##
  ## TODO: move processing to controllers
  ##
  ## TODO: add 'ping'
  ##
  ## TODO: add authentication and authorization
  ##
  ## TODO: Full set of tests

  def respond (message)
    ## TODO: Move this to a helper place
    render text: "<Response>#{message}</Response>", content_type: "text/xml"
  end
  
  def respond_to_sms(message)
    respond("<sms>#{message}    *** built by 41monkeys  **** built on and supported by Twilio</sms>")
  end

  def respond_to_call(message)
    respond(:call, message)
  end

  def sms
    body      = params[:Body].split
    phone     = params[:From]
    to        = params[:To]

    # logger.debug('~~~~~~~~~ calling event SMS ' + params.to_yaml)
    case body[0].downcase

    ##
    ## Events
    ##
    when "event"         
      message = Event.sms(params, body)
      respond_to_sms(message)

    when "add"
      message = Doorman.add(phone) 
      respond_to_sms(message)

    when "remove" 
      message = Doorman.remove(phone)
      respond_to_sms(message)

    when "door"
      message = Doorman.door(phone, @client)
      respond_to_sms(message)

    else
      respond_to_sms("SAY WHAT?  Send 'door' to get in")
    end
  end


  def call
    logger.debug('~~~~~~~~~ calling event call ' + params.to_yaml)
    # logger.debug('~~~~~~~~~ calling event call ' + params[:From])
    
    
    params[:From] == '+14155154361' ? say = "<Say>Hello Ken. Thank you for calling</Say>" : say = ""
    params[:From] == '+12063038222' ? say = "<Say>Hello Skander. Thank you for calling</Say>" : say = ""
    params[:From] == '+12148685961' ? say = "<Say>Hello Parental Unit. Thank you for calling</Say>" : say = ""
    params[:From] == '+18163650563' ? say = "<Say>Hello Kris. Thank you for calling</Say>" : say = ""

    now = DateTime.now
    mdays = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth', 'fourteenth', 'fifteenth', 'sixteenth', 'seventeenth', 'eighteenth', 'nineteenth', 'twentieth', 'twenty-first', 'twenty-second', 'twenty-third', 'twenty-fourth', 'twenty-fifth', 'twenty-sixth', 'twenty-seventh', 'twenty-eighth', 'twenty-ninth', 'thirtieth', 'thirty-first']
    say = now.strftime('it is now ') + now.strftime('%M').to_i.to_s + now.strftime(' minutes after %l %p on %A, the ' ) + mdays[now.strftime('%e').to_i] + now.strftime(' day of %B in the year %Y' )
    respond("<Say>#{say}. Please call again.</Say>")
    
    
    
    # respond("<Say voice='woman'  language='fr'>Bonjour Skander.  Tu fais chier! au revoir.</Say><Status>completed</Status>")
    # if params[:From] == '+12063038222'
    #   if params[:Digits]
    #     respond("<Say voice='woman' language='fr'>Thank you but You STILL suck. Good bye.</Say>")
    #   else
    #     respond("<Gather finishOnKey='any digit'><Say voice='woman'>Hi there Skander.  You suck. Please press 1.</Say></Gather>")
    #   end
    # end    
  end
  
  private

  def twilio_init
    @client   = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
  end

end


# {"AccountSid"=>"ACbbefae45e9c349aa931498bd315c85e1" 
#  "Body"=>"add" 
#  "ToZip"=>"94949" 
#  "FromState"=>"WA" 
#  "ToCity"=>"NOVATO" 
#  "SmsSid"=>"SM159a1d5ba1127f06c443ff4897ad1b82" 
#  "ToState"=>"CA" 
#  "To"=>"4155992671" 
#  "ToCountry"=>"US" 
#  "FromCountry"=>"US" 
#  "SmsMessageSid"=>"SM159a1d5ba1127f06c443ff4897ad1b82" 
#  "ApiVersion"=>"2008-08-01" 
#  "FromCity"=>"SEATTLE" 
#  "SmsStatus"=>"received" 
#  "From"=>"2066298883" 
#  "FromZip"=>"98109" 
#  "action"=>"sms" 
#  "controller"=>"application"}




# {"AccountSid"=>"ACbbefae45e9c349aa931498bd315c85e1"
#  "ToZip"=>""
#  "FromState"=>"CA"
#  "Called"=>"+12065351536"
#  "FromCountry"=>"US"
#  "CallerCountry"=>"US"
#  "CalledZip"=>""
#  "Direction"=>"inbound"
#  "FromCity"=>"SAN FRANCISCO"
#  "CalledCountry"=>"US"
#  "CallerState"=>"CA"
#  "CallSid"=>"CA74c69e5ae1be18b65cf66dfeb5750c46"
#  "CalledState"=>"WA"
#  "From"=>"+14155154361"
#  "CallerZip"=>"94956"
#  "FromZip"=>"94956"
#  "CallStatus"=>"ringing"
#  "ToCity"=>""
#  "ToState"=>"WA"
#  "To"=>"+12065351536"
#  "ToCountry"=>"US"
#  "CallerCity"=>"SAN FRANCISCO"
#  "ApiVersion"=>"2010-04-01"
#  "Caller"=>"+1#{the phone number}"
#  "CalledCity"=>""}

