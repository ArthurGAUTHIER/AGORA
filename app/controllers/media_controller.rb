class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  def index #search_in_all(params[:query])
    if !params[:q].blank?
      @media = Medium.first(2) #TOCHANGE
    elsif !params[:adv].blank?
      @media = Medium.last(2)
    else
      @media = Medium.all
    end
  end
end
