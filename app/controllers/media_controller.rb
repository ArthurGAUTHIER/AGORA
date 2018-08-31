class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if !params[:q].blank? && !advanced_search?
      @media = Medium.search_in_all(params[:q])
    elsif advanced_search?
      @media = Medium.last(2)
    else
      @media = Medium.all
    end
  end

  private

  def advanced_search?
    !(
      params[:adv][:category].blank? &&
      params[:adv][:mood].blank? &&
      params[:adv][:country].blank? &&
      params[:adv][:actor].blank? &&
      params[:adv][:director].blank? &&
      params[:adv][:studio].blank? &&
      params[:adv][:seen].nil? &&
      params[:adv][:recent].nil? &&
      params[:adv][:netflix].nil? &&
      params[:adv][:amazon].nil?
    ) # TODO : add rule for year and duration
  end
end
