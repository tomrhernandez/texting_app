class StoresController < ApplicationController
  before_action :require_user, only: [:index, :edit, :update, :new]
  before_action :set_no_cache, only: [:index, :edit, :update, :new]
  
  # Get store object ready for creation.
  def new
    @store = Store.new
  end
  
  #def create
  #  logger.warn "*** BEGIN RAW REQUEST HEADERS ***"
  #    self.request.env.each do |header|
  #      logger.warn "#{header[0]}:#{header[1]}"
  #      #logger.warn "#{header[1]}"
  #    end
  #  logger.warn "*** END RAW REQUEST HEADERS ***"
  #  
  #end
  
  def destroy
    Store.find(params[:id]).delete
    flash[:success] = "Store Deleted"
    redirect_to stores_path
  end
  
  # Create new store.
  def create
    @store = Store.new(store_params)
    if @store.save
      flash[:success] = "Store Created"
      redirect_to stores_path
    else
      render 'new'
    end
  end
  
  # Store listing, find messages in date range.
  def index
    @stores = Store.all
    @search = MessageSearch.new(params[:search])
    @messages = @search.scope
  end
  
  # Edit a store.
  def edit
    @store = Store.find(params[:id])
    #@store = Store.second
  end
  
  # Update existing store.
  def update
    @store = Store.find(params[:id])
    @store.update(store_params)
    flash[:success] = "Store Updated"
    redirect_to stores_path
  end
  
  # Find by NABP number, check for API key and secret, only show incoming messages.
  def inbox
    if Store.verify_key_and_secret(params[:api_key], params[:api_secret])
      @store = Store.find_by(nabp: params[:nabp])
      if @store.nil?
       render :text => "Store with that nabp #{params[:nabp]} number not found" and return
      else
        @messages = @store.messages
        render layout: false
      end
    else
      render :text => "API Key and secret not valid"
    end
    #render layout: false
  end
  
  private
  
  def store_params
      params.require(:store).permit(:name, :phone, :nabp)
  end
 
  
end
