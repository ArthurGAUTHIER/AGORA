class PreferenceMoodsController < ApplicationController
  def create
    @mood = Mood.find(params[:mood_id])
    @preference_mood = PreferenceMood.new(user: current_user, mood: @mood)
    if @preference_mood.save
      redirect_to dashboard_path
    else
      render 'dashboard'
    end
  end
end
