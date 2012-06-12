module ApplicationHelper

  def ilink_to(*args, &block)
    if block_given?
      icon = args[0]
      options = args[1] || {}
      html_options = args[2]
      ilink_to(icon, capture(&block), options, html_options)
    else
      icon = args[0]
      name = args[1]
      options = args[2] || {}
      html_options = args[3]

      html_options = convert_options_to_data_attributes(options, html_options)
      url = url_for(options)

      href = html_options['href']
      tag_options = tag_options(html_options)

      href_attr = "href=\"#{ERB::Util.html_escape(url)}\"" unless href
      "<a #{href_attr}#{tag_options}><i class=\"icon-#{icon}\"></i> #{ERB::Util.html_escape(name || url)}</a>".html_safe
    end
  end
end

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
