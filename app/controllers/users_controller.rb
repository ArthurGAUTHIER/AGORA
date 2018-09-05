class UsersController < ApplicationController
  def show

  end

  def user_params
    params.require(:article).permit(:alias, :email, :photo)
  end

  def media_count
    Library.all.where(already_watched: true, user: current_user).each do |instance|
      return instance.count
    end
  end

  def time_spent
  end

  def favorite
  end

  def average_duration
  end
end
