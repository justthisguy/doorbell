class Event < ActiveRecord::Base
  attr_accessible :duration, :frequency, :name, :reserves, :start
  serialize :reserves, Array
  

  def self.sms    
    
    Rails.logger.debug('************************** event SMS ' + rest.to_s)
    
    
      phone = params[:From]
      Rails.logger.debug('************************** command ' + command.to_s)

      case rest[0]
        when "new"
          if event = Event.find_by_name(rest[1]) 
            return render :text => '<Response><Sms>this event already exists</Sms></Response>', :content_type => "text/xml"
          end
          
          event = Event.new(name => rest[1])
          render :text => '<Response><Sms>event created</Sms></Response>', :content_type => "text/xml"

        when "add"
          # event add event_name 
          event = Event.find_by_name(rest[1]) 
          if event 
            event.reserve << phone
            render :text => "<Response><Sms>You have been added to the reserves for #{event.name} </Sms></Response>", :content_type => "text/xml"
          else
            render :text => '<Response><Sms>this event does not exists</Sms></Response>', :content_type => "text/xml"
          end
          

        else;
          render :text => "<Response><Sms>SAY WHAT?  Send 'door' to get in/Sms></Response>", :content_type => 'text/xml'
      end
    end
    
  end

end