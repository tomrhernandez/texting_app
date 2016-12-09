class StoresController < ApplicationController
  
  def index
    
  end
  
  # Find by NABP number and only show incoming messages
  def inbox
    
    @store = Store.find_by(nabp: params[:nabp])
    if @store.nil?
      render :text => "Store with that nabp #{params[:nabp]} number not found" and return
    else
      @messages = @store.messages
    end
    render layout: false
  end
  
  # Show incoming & outgoing messages
  def all
    @store = Store.find_by(nabp: params[:nabp])
    @messages = @store.messages
  end
  
end
