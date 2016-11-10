class SmsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    SinchSms.send("bf375dd8-9401-4dbb-864e-e15033adb64e", "4DHrjcAprEq9JvTH+LAYMw==", params[:message], params[:to])
    
    render :nothing => true
  end
  
end
