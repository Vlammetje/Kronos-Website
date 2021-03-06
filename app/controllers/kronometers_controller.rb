class KronometersController < ApplicationController
  authorize_resource
  def index
    @kms = Kronometer.order('date DESC')
    @users = User.where(:papieren_kronometer => true)
  end
  
  def new
    @km = Kronometer.new
  end
  
  def create
    km = Kronometer.new(params[:kronometer])
    if km.save
      redirect_to kronometers_path
      flash[:success] = "Kronometer succesvol geupload."
    else
      render 'new'
    end
  end
  
  def edit
    @km = Kronometer.find(params[:id])
  end
  
  def update
    km = Kronometer.find(params[:id])
    km.update_attributes(params[:kronometer])
    if km.save
      redirect_to kronometers_path
      flash[:success] = "Kronometer succesvol aangepast"
    else
      render 'edit'
    end
  end
  
  def destroy
    km = Kronometer.find(params[:id])
    km.destroy
    redirect_to kronometers_path
    flash[:success] = "Kronometer succesvol verwijderd"
  end
  
  def labels
    @users = User.where(:papieren_kronometer => true)
    
    respond_to do |format|
      format.pdf do
        render :pdf => "kronometer stickers #{Time.now}"
      end
    end
  end
end
