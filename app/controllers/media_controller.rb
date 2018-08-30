class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if advanced_search?
      @media = Medium.all #TOCHANGE
    elsif simple_search?
      @media = Medium.search_in_all(params[:query])
    else
      @media = Medium.all
    end
  end

  private

  def advanced_search?
    params[:category] ||
    params[:actor] ||
    params[:director] ||
    params[:mood] ||
    params[:studio] ||
    params[:year] ||
    params[:duration] ||
    params[:recent] ||
    params[:seen] ||
    params[:netflix] ||
    params[:amazon]

  end

  def simple_search?
    params[:query]
  end
end
