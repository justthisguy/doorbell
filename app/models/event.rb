class Event < ActiveRecord::Base
  attr_accessible :duration, :frequency, :name, :reserves, :start
  serialize :reserves, Array
  
  # def initialize (new_name)
  #   name = new_name
  #   Rails.logger.debug('************************** event initialize ' + self.inspect)
  #   
  # end
  # 

  def self.sms (params, body)    
    
      phone = params[:From]

      case body[1]
        when "new"

          if event = Event.find_by_name(body[2]) 
            Rails.logger.debug('************************** event already exists ' + body.to_s)
            return 'this event already exists'
          end
          Rails.logger.debug('************************** event need to make new ' + body[2])
          
          event = Event.new()
          event.name = body[2] 
          event.reserves = []
          Rails.logger.debug('************************** event looks like this ' + event.inspect)#  + "   the name is " + event.name)
          
          event.save!
          return  'event created'

        when "add"
          # event add event_name 
          event = Event.find_by_name(body[2]) 
          if event 
            event.reserves << phone
            event.save
            return "You have been added to the reserves for #{event.name} "
          else
            return 'this event does not exists'
          end
          

        else
          return "SAY WHAT?  Send 'door' to get in"
      end

    
  end

end