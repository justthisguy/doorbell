class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :twilio_init


  ## TODO: Move this to a helper place
  ##
  def respond (message)
    render text: "<Response><Sms>#{message}</Sms></Response>", content_type: "text/xml"
  end

  def sms
    body      = params[:Body].split
    phone     = params[:From]

    case body[0]

      # Rails.logger.debug('************************** calling event SMS ' + body.to_s)

      ##
      ## Door section
      ##
    when "add"
      message = Doorman.add(phone) 
      respond(message)

    when "remove" 
      message = Doorman.remove(phone)
      respond(message)

    when "door"
      message = Doorman.door(phone, @client)
      respond(message)


      ##
      ## Events
      ##
    when "event"         
      message = Event.sms(params, body)
      respond(message)


    else
      respond("SAY WHAT?  Send 'door' to get in")
    end
  end


  private

  def twilio_init
    @client   = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
  end


end
