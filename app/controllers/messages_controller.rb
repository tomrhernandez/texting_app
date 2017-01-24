class MessagesController < ApplicationController
  #before_filter :verify_key_and_secret
  skip_before_action :verify_authenticity_token
  
  def show
    logger.warn "*** BEGIN RAW REQUEST HEADERS ***"
      self.request.env.each do |header|
        logger.warn "#{header[0]}:#{header[1]}"
        #logger.warn "#{header[1]}"
      end
    logger.warn "*** END RAW REQUEST HEADERS ***"
    
  end
  
  # Mark messages read.
  def update
    if Message.verify_key_and_secret(params[:api_key], params[:api_secret])
      @message = Message.find(params[:id])
      @message.update(qs_read: true)
      render :text => "Message ID #{@message.id}  updated successfully! Qs_read: #{@message.qs_read}"
    else 
      render :text => "API Key and secret not valid"
    end  
  end
  
  # Takes POST method and shows url header information. Use for debugging.
  def create2
    logger.warn "*** BEGIN RAW REQUEST HEADERS ***"
      self.request.env.each do |header|
        logger.warn "#{header[0]}:#{header[1]}"
        #logger.warn "#{header[1]}"
      end
    logger.warn "*** END RAW REQUEST HEADERS ***"
  end
  
  # Send and receive messages. Save to database.
  def create
    
    # Do this if the event is incoming. We get the incomingSms event from Sinch.
    if params[:event] == "incomingSms"
      # Check the authorization header.
      if Message.verify_sinch_origin(request.headers['HTTP_AUTHORIZATION'][0..47])
        @store = Message.find_store(params[:to][:endpoint])
        @message = Message.new({:to => params[:to][:endpoint], :from => params[:from][:endpoint], :message => params[:message], :store_id => @store.id})
        @message.save
      end
      render :nothing => true
      
    else
      
      # If its not incoming, treat it as outgoing.
      @store = Message.find_store(params[:from])
      # Raise error if we don't find the store's phone number.
      if @store.nil?
        render :text => 'Store with that number not found', :status => 400
      else
        if Message.verify_key_and_secret(params[:api_key], params[:api_secret])
            #render :text => 'api key and secret passed'
            @message = Message.new({:to => params[:to], :from => @store.phone, :message => params[:message], :store_id => @store.id, :qs_read => true})
            @message.save
            #SinchSms.send(ENV["SINCH_API_KEY"], ENV["SINCH_API_SECRET"], params[:message], params[:to], params[:from])
            SinchSms.send(ENV["sinch_api_key"], ENV["sinch_api_secret"], params[:message], params[:to], params[:from])
            render :text => "Message delivered!"
        else
           render :text => "API Key and Secret not valid"
        end
      end
    end
  end
end
