class ApplicationController < ActionController::Base
  protect_from_forgery

  @@twilios_number = 'not a number'

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
    logger.debug('~~~~~~~~~ calling event call start ' + params.to_yaml)
    logger.debug('~~~~~~~~~ calling event call start @@twilios_number  ' + @@twilios_number.to_s)
        
    if    params[:Digits] == '536'
      @@twilios_number = params[:From]
      logger.debug('~~~~~~~~~ calling event call  @@twilios_number  ' + @@twilios_number.to_s)
      twilio
    elsif params[:From] == make_voice_number(ENV['skander_phonenumber']) 
      skander
    elsif params[:From] == make_voice_number(ENV['angie_phonenumber']) 
      angie
    elsif params[:From] == make_voice_number(ENV['carter_phonenumber'])
      carter
    elsif params[:From] == make_voice_number(ENV['twilio_phonenumber'])  || params[:From] == @@twilios_number
      twilio
    else
      time
    end   
  end
  
  
  def twilio
    case params[:Digits]
    when '1'
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'TWILIO ~~ LIKE.' )
      respond("<Gather numDigits='1'><Say voice='woman'>Thank you. You are kind.</Say><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '2'
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'TWILIO ~~ AMAZING.' )
      respond("<Gather numDigits='1'><Say voice='woman'>Thank you very much. You are so kind.  Ken is excited to talk to you.</Say><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '3'
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'TWILIO ~~ sucks :( ' )
      respond("<Gather numDigits='1'><Say voice='woman'>Your manager is fantastic. Please thank them for me.  Ken is excited about Twilio.</Say><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '4', '5', '6', '7', '8' 
      respond("<Gather numDigits='1'><Play>http://41monkeys.com/wise_guya.mp3</Play><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '9' 
      logger.debug('~~~~~~~~~ calling event call pound key  ' + "<Dial>#{make_voice_number(ENV['ken_phonenumber'])}</Dial>")
      respond("<Dial>#{make_voice_number(ENV['ken_phonenumber'])}</Dial>") 
    else
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'TWILIO is calling.' )
      respond("<Gather numDigits='1'><Say voice='woman'>Hello Twilio. Thank you for your interest. If you were impressed with my application, Please press 1. If you thought, WOW, Ken is amazing, Please press 2. If you are calling only cause your manager made you, Please press 3.</Say></Gather>")
    end
  end
  
  def carter
    case params[:Digits]
    when '1'
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'Carter pressed ONE.' )
      respond("<Gather numDigits='1'><Say voice='woman'>Yeah.  You are right. Rails is pretty great.</Say><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '2'
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'Carter pressed TWO.' )
      respond("<Gather numDigits='1'><Say voice='woman'>I like San Francisco too.</Say><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '3'
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'Carter pressed THREE' )
      respond("<Gather numDigits='1'><Say voice='woman'>Joe's Pizzaria.  What can I get you?</Say><Pause/><Say voice='woman'>Just kidding.  I don't have any pizza. To talk to Ken, Please press nine.</Say></Gather>")
    when '4', '5', '6', '7', '8' 
      respond("<Gather numDigits='1'><Play>http://41monkeys.com/wise_guya.mp3</Play><Pause/><Say voice='woman'> To talk to Ken, Please press nine.</Say></Gather>")
    when '9' 
      logger.debug('~~~~~~~~~ calling event call pound key  ' + "<Dial>#{make_voice_number(ENV['ken_phonenumber'])}</Dial>")
      respond("<Dial>#{make_voice_number(ENV['ken_phonenumber'])}</Dial>") 
    else
      @client.account.sms.messages.create(from: '2065351536', to: ENV['ken_text_phonenumber'],  body: 'Carter is in it.' )
      respond("<Gather numDigits='1'><Say voice='woman'>Hello Carter. Your mission, should you choose to accept it, </Say><Pause/><Say voice='woman'>Wait. That's not for you.</Say><Pause/><Say voice='woman'>Did I mention how hansome you look? Ok. down to business. If you thinks Rails great. Please press 1. If San Francisco is a nice city. Please press 2. If you would like to order pizza.  Please press 3. </Say></Gather>")
    end    
  end
  
  def skander
    # respond("<Say voice='woman'  language='fr'>Bonjour Skander.  Tu fais chier! au revoir.</Say><Status>completed</Status>")
    # if params[:Digits]
    #   respond("<Say voice='woman' language='fr'>Thank you but You STILL suck. Good bye.</Say>")
    # else
    #   respond("<Gather finishOnKey='any digit'><Say voice='woman'>Hi there Skander.  You suck. Please press 1.</Say></Gather>")
    # end
    case params[:Digits]
    when '1'
      respond("<Say voice='woman'>Thank you but You STILL suck. Good bye.</Say>")
    when '2'
      respond("<Say voice='woman' language='fr'>Bonjour Skander.  Tu fais chier! au revoir.</Say>")
    else
      respond("<Gather finishOnKey='any digit' timeout='5' numDigits='1'><Say voice='woman'>Hi there Skander.  You suck. To proceed in English, Please press 1. To proceed in French, Please press 2.</Say></Gather>")
    end
  end
  
  def angie
    case params[:Digits]
    when '1'
      respond("<Say>You ARE most wonderfully fantastic.  You Pop ee thinks so too.</Say>")
    when '2'
      respond("<Say>Your Pop ee misses you very very much.</Say>")
    when '3', '4', '5', '6', '7', '8' 
      respond("<Play>http://41monkeys.com/softkitty.mp3</Play>")
    else
      respond("<Gather finishOnKey='any digit' timeout='5' numDigits='1'><Say>Hello little girl.  If you are fantastic, Please press 1. If you miss your Pop ee, Please press 2.  For a surprise, Please press 3</Say></Gather>")
    end   
  end
  
  def time
    if params[:From] == make_voice_number(ENV['ken_phonenumber'])
      then intro = "<Say>Hello Ken. Thank you for calling. </Say>"
    elsif params[:From] == make_voice_number(ENV['skander_phonenumber']) 
      intro = "<Say>Hello Skander. Thank you for calling. </Say>"
    elsif params[:From] == make_voice_number(ENV['angie_phonenumber']) 
      intro = "<Say>Hello little girl. Who is a princess? </Say>"
    elsif params[:From] == make_voice_number(ENV['parent_phonenumber'])
      intro = "<Say>Hello Parental Unit. Thank you for calling. </Say>"
    elsif params[:From] == make_voice_number(ENV['kris_phonenumber']) 
      intro = "<Say>Hello Kris. Thank you for calling. </Say>"
    else
      intro = "<Say>Hello. Thank you for calling. </Say>"
    end
    logger.debug('~~~~~~~~~ calling event call person found? ' + intro)
    
    now = DateTime.now
    mdays = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth', 'fourteenth', 'fifteenth', 'sixteenth', 'seventeenth', 'eighteenth', 'nineteenth', 'twentieth', 'twenty-first', 'twenty-second', 'twenty-third', 'twenty-fourth', 'twenty-fifth', 'twenty-sixth', 'twenty-seventh', 'twenty-eighth', 'twenty-ninth', 'thirtieth', 'thirty-first']
    time_string = now.strftime('it is now ') + now.strftime('%M').to_i.to_s + now.strftime(' minutes after %l %p on %A, the ' ) + mdays[now.strftime('%e').to_i] + now.strftime(' day of %B in the year %Y . ' )
 
    say = intro + "<Pause/><Say>" + time_string + "Please call again. Good bye.</Say>"

    logger.debug('~~~~~~~~~ calling event call say? ' + say)

    respond("<Gather timeout='1' numDigits='3'>#{say}</Gather>")    
  end
  
  
  private

  def twilio_init
    @client   = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
  end
  
  def make_voice_number(number)
    "+1#{number}"
  end

end

### SMS
# {"AccountSid"=>"ACbbefae45e9c349aa931498bd315c85e1" 
#  "Body"=>"add" 
#  "ToZip"=>"94949" 
#  "FromState"=>"WA" 
#  "ToCity"=>"NOVATO" 
#  "SmsSid"=>"SM159a1d5ba1127f06c443ff4897ad1b82" 
#  "ToState"=>"CA" 
#  "To"=>"#{inbound number}" 
#  "ToCountry"=>"US" 
#  "FromCountry"=>"US" 
#  "SmsMessageSid"=>"SM159a1d5ba1127f06c443ff4897ad1b82" 
#  "ApiVersion"=>"2008-08-01" 
#  "FromCity"=>"SEATTLE" 
#  "SmsStatus"=>"received" 
#  "From"=>"#{incoming number}" 
#  "FromZip"=>"98109" 
#  "action"=>"sms" 
#  "controller"=>"application"}



### VOICE
# {"AccountSid"=>"ACbbefae45e9c349aa931498bd315c85e1"
#  "ToZip"=>""
#  "FromState"=>"CA"
#  "Called"=>"+1#{inbound number}"
#  "FromCountry"=>"US"
#  "CallerCountry"=>"US"
#  "CalledZip"=>""
#  "Direction"=>"inbound"
#  "FromCity"=>"SAN FRANCISCO"
#  "CalledCountry"=>"US"
#  "CallerState"=>"CA"
#  "CallSid"=>"CA74c69e5ae1be18b65cf66dfeb5750c46"
#  "CalledState"=>"WA"
#  "From"=>"+1#{originating number}"
#  "CallerZip"=>"94956"
#  "FromZip"=>"94956"
#  "CallStatus"=>"ringing"
#  "ToCity"=>""
#  "ToState"=>"WA"
#  "To"=>"+1#{inbound number}"
#  "ToCountry"=>"US"
#  "CallerCity"=>"SAN FRANCISCO"
#  "ApiVersion"=>"2010-04-01"
#  "Caller"=>"+1#{originating number}"
#  "CalledCity"=>""}

