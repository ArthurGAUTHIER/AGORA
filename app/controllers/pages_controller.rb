class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  layout 'home'

  def home
    session.delete(:media) unless session[:media].nil?
  end
end
