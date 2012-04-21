class DoormenController < ApplicationController
  # GET /doormen
  # GET /doormen.json
  def index
    @doormen = Doorman.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @doormen }
    end
  end

  # GET /doormen/1
  # GET /doormen/1.json
  def show
    @doorman = Doorman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @doorman }
    end
  end

  # GET /doormen/new
  # GET /doormen/new.json
  def new
    @doorman = Doorman.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @doorman }
    end
  end

  # GET /doormen/1/edit
  def edit
    @doorman = Doorman.find(params[:id])
  end

  # POST /doormen
  # POST /doormen.json
  def create
    @doorman = Doorman.new(params[:doorman])

    respond_to do |format|
      if @doorman.save
        format.html { redirect_to @doorman, notice: 'Doorman was successfully created.' }
        format.json { render json: @doorman, status: :created, location: @doorman }
      else
        format.html { render action: "new" }
        format.json { render json: @doorman.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /doormen/1
  # PUT /doormen/1.json
  def update
    @doorman = Doorman.find(params[:id])

    respond_to do |format|
      if @doorman.update_attributes(params[:doorman])
        format.html { redirect_to @doorman, notice: 'Doorman was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @doorman.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doormen/1
  # DELETE /doormen/1.json
  def destroy
    @doorman = Doorman.find(params[:id])
    @doorman.destroy

    respond_to do |format|
      format.html { redirect_to doormen_url }
      format.json { head :no_content }
    end
  end
  
  def sms
    
    Rails.logger.debug("******************** these be the params #{params} ")
    
    name = params[:Body] 
    phone = params[:From]
    
    case name
      when /add/; 
        doorman = Doorman.new
        doorman.phone = phone
        doorman.save
        
        Rails.logger.debug('new doorman ' + doorman.to_s)
        render :text => '<Response><Sms>add</Sms></Response>', :content_type => "text/xml"
        
      when /remove/; 
        doorman = Doorman.find_by_phone(phone)
        
        if doorman.destroy 
          render :text => '<Response><Sms>You have been removed. SURF thanks you for your help.</Sms></Response>', :content_type => "text/xml"
        end
        
      when /door/; 
        account_sid = 'ACbbefae45e9c349aa931498bd315c85e1'
        auth_token = '748a6fa66c8d70882fdbb9424b5c0944'
        @client = Twilio::REST::Client.new account_sid, auth_token

        Doorman.all.each { |d|
          
          Rails.logger.debug("doorman message to #{d.phone} from #{phone}")
          
          @client.account.sms.messages.create(
            :from => '4155992671',
            :to => d.phone,
            :body => phone + ' is at the door'
            )
            
        }
        
        render :text => '<Response><Sms>Give us a minute please. Help is on the way.</Sms></Response>', :content_type => "text/xml"
      
      else;
        render :text => '<Response><Sms>SAY WHAT?/Sms></Response>', :content_type => 'text/xml'
    end
  end

end
