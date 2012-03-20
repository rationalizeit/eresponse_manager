class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user,  :mobile_device?
  before_filter :prepare_for_mobile
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
end
