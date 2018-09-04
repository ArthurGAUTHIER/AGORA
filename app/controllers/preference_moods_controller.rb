class PreferenceMoodsController < ApplicationController
  def create
    @mood = Mood.find(params[:mood_id])
    @preference_mood = PreferenceMood.create(user: current_user, mood: @mood)
    if @preference_mood.valid?
      redirect_to dashboard_path
    else
      render 'dashboard'
    end
  end

  def destroy
    @preference_mood = PreferenceMood.find(params[:id])
    @preference_mood.destroy
    redirect_to dashboard_path
  end
end
