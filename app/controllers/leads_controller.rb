class LeadsController < ApplicationController
  def index
  end

  def lead
  end

  def refresh_leads
    GetEmails.perform
    redirect_to :back
    #flash[:notice] = 'Your request has been queued. Please check this page in a few minutes'
    #render :text => 'Your request has been queued. Please check this page in a few minutes'
  end
end
