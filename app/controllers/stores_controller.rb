class StoresController < ApplicationController
  before_action :require_user, only: [:index, :edit, :update, :new]
  
  def new
    @store = Store.new
  end
  
  def create
    @store = Store.new(name: params[:store][:name], phone: params[:store][:phone], nabp: params[:store][:nabp])
    if @store.save
      flash[:success] = "Store Created"
      redirect_to stores_path
    else
      render 'new'
    end
  end
  
  
  def index
    @stores = Store.all
  end
  
  def edit
    @store = Store.find_by(id: params[:id])
    #@store = Store.second
  end
  
  def update
    @store = Store.find_by(id: params[:id])
    @store.update(name: params[:store][:name], phone: params[:store][:phone], nabp: params[:store][:nabp])
    flash[:success] = "Store Updated"
    redirect_to stores_path
  end
  
  # Find by NABP number and only show incoming messages
  
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
  
  # Show incoming & outgoing messages
  #def all
  #  @store = Store.find_by(nabp: params[:nabp])
  #  @messages = @store.messages
  #end
  
  
  
end
