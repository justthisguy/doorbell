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
            return 'this event already exists'
          end
          
          event = Event.new()
          event.name = body[2] 
          event.reserves = []
          
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

        when "remove"
          # event remove event_name 
          event = Event.find_by_name(body[2]) 
          if event 
            event.reserves.delete(phone)
            event.save
            return "You have been removed from the reserves for #{event.name} "
          else
            return 'this event does not exists'
          end


          else
            return "SAY WHAT?  Send 'door' to get in"
        end

    
  end

end