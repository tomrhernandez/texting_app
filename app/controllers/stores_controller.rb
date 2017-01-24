class StoresController < ApplicationController
  before_action :require_user, only: [:index, :edit, :update, :new]
  
  # Get store object ready for creation.
  def new
    @store = Store.new
  end
  
  # Create new store.
  def create
    @store = Store.new(name: params[:store][:name], phone: params[:store][:phone], nabp: params[:store][:nabp])
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
    @store.update(name: params[:store][:name], phone: params[:store][:phone], nabp: params[:store][:nabp])
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
 
  
end
