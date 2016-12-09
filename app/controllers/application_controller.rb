class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  # this helper method will make these methods avaible to the views
  helper_method :current_user, :logged_in?

  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
      !!current_user
  end

  def require_user
      if !logged_in?
          render :text => "You must be logged in to perform that action"
      end
  end
  
end
