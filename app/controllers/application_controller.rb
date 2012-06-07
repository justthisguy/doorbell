class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :twilio_init

  ## TODO: decide on data model
  ##
  ## TODO: move processing to controllers
  ##
  ## TODO: add 'ping'
  ##
  ## TODO: add authentication and authorization
  ##
  ## TODO: Perhaps move to MongoDB
  ##
  ## TODO: Full set of tests
  ##
  ## TODO: better design elements
  ##



  ## TODO: Move this to a helper place
  ##
  def respond (message)
    render text: "<Response><Sms>#{message} /r=> built by 41monkeys /r=> built on and supported by Twilio</Sms></Response>", content_type: "text/xml"
  end

  def sms
    body      = params[:Body].split
    phone     = params[:From]
    to        = params[:To]

    #
    # SEE BELOW FOR A FULL PARAMS SET
    #
    # Rails.logger.debug('************************** calling event SMS ' + params.to_s)

    case body[0].downcase

    ##
    ## Events
    ##
    when "event"         
      message = Event.sms(params, body)
      respond(message)


    when "add"
      # Rails.logger.debug('************************** calling event add ' + body.to_s)
      message = Doorman.add(phone) 
      respond(message)

    when "remove" 
      message = Doorman.remove(phone)
      respond(message)

    when "door"
      message = Doorman.door(phone, @client)
      respond(message)




      ##
      ## Door section -- Everything else gets passed to Door
      ##
    else
      respond("SAY WHAT?  Send 'door' to get in")
    end
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
