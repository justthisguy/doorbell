class Doorman < ActiveRecord::Base
  attr_accessible :phone
  
  def self.add (phone)
    if !Doorman.find_by_phone(phone)
      doorman = Doorman.new
      doorman.phone = phone
      doorman.save    
    end
    
    return 'You are a doorman. SURF thanks you for your help.'
  end
  
  def self.remove (phone)
    if doorman = self.find_by_phone(phone) 
      doorman.destroy
      doorman.save
    end

    return 'You are no longer a doorman. SURF thanks you for your help.'
  end
  
  def self.door (phone, client)

    return 'Sorry, there no doormen at the moment.' if self.all.empty?

    self.all.each do |d|
      client.account.sms.messages.create(
        from: '2065351536',
        to: d.phone,
        body: phone + ' is at the door.   \r\n* built by 41monkeys  \r\n* built on and supported by Twilio'
        )
    end

    return 'Give us a minute please. Help is on the way'
  end
  
end
