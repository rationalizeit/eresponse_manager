class LeadsController < ApplicationController
  def index
    @leads = Lead.find(:all, :order => 'captured_on desc')
    end
  

  def lead
  end
  
  def destroy
    Lead.find(params[:id]).destroy if params[:id] 
    redirect_to root_path
  end
  def refresh_leads
    GetEmails.perform
    redirect_to root_path
    #flash[:notice] = 'Your request has been queued. Please check this page in a few minutes'
    #render :text => 'Your request has been queued. Please check this page in a few minutes'
  end
  
  def show
    @lead = Lead.find(params[:id])
  end
end
