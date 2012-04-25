class Doorman < ActiveRecord::Base
  attr_accessible :phone
  
  def self.add (phone)
    if doorman = Event.find_by_phone(phone) 
      Rails.logger.debug('************************** doorman already exists ' + doorman.inspect)
      return 'this event already exists'
    end
    Rails.logger.debug('************************** doorman need to make new ' + phone)
    
    doorman = Doorman.new
    doorman.phone = phone
    doorman.save    
  end
  
end
