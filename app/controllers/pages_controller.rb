class PagesController < ApplicationController
  before_filter :authenticate, :only => [:admin]
  def home
  end

  def show
    @page = Page.find_by_pagetag(params[:pt])
  end
    
  def test
  end
  
  def edit
    @page = Page.find_by_pagetag(params[:pt])
  end
  
  def update
    @page = Page.find_by_pagetag(params[:pt])
    
    if(current_user)
      @page.user = current_user;
    end

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to '/'+@page.pagetag, notice: 'Page was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def nieuw
    if(current_user)
      @users = User.where(:created_at => (current_user.last_login_at)..(Time.now)).paginate(:page => params[:page], :order => 'created_at DESC', :per_page => 10)
      @chatmessages = Chatmessage.where(:created_at => (current_user.last_login_at)..(Time.now)).paginate(:page => params[:page], :order => 'created_at DESC', :per_page => 10)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chatmessages }
    end
  end
end
