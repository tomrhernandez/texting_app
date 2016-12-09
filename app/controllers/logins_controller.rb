class LoginsController < ApplicationController
    
   def new
       
   end
   
   def create
       user = User.find_by(username: params[:username])
       if user && user.authenticate(params[:password])
           session[:user_id] = user.id
           flash[:success] = "You are logged in"
           redirect_to stores_path
           
       else
           flash[:danger] = "Your email address or password does not match"
           render 'new'
       end
   end
   
   def destroy
       session[:user_id] = nil
       flash[:success] = "You have logged out"
       render :text => "You have logged out"
   end
    
    
end