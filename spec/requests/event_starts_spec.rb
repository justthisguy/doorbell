require 'spec_helper'

describe "Event Start and End" do
  it 'adds the numbers from the reserve into the doormen list' do
    #let(:event) { FactoryGirl.create(:event, :name => "SeattleOnRails") }
    @event = FactoryGirl.create :event, :name => "SeattleOnRails"
    
    # puts "****************************** " + @event.inspect
    
    # there should be no doorment before
    Doorman.all.should have(0).items
    
    visit events_path
    click_link 'Start'
    
    # there should be the same number of doorment as there are reserves in the event
    Doorman.all.should have(@event.reserves.count).items
    
    
    ### TODO: how do we test to ensure each reserve is on the doormen list??
    ###
    # @event.reserves.each do |r| 
    #   Doorman.all.should include(r)
    # end


    visit events_path
    click_link 'End'

    # there should be no doorment before
    Doorman.all.should have(0).items

    
  end
  
end
